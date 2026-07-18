<?php
require_once __DIR__ . '/helper/Database.php';
require_once __DIR__ . '/helper/Response.php';
require_once __DIR__ . '/helper/Validator.php';
require_once __DIR__ . '/helper/Token.php';

use Api\Helper\Database;
use Api\Helper\Response;
use Api\Helper\Validator;
use Api\Helper\Token;

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    Response::error('Method not allowed', 405);
}

$input = json_decode(file_get_contents('php://input'), true) ?? $_POST;
$email = Validator::sanitizeEmail($input['email'] ?? null);
$otp = Validator::sanitizeString($input['otp'] ?? null);

if (!$email || !$otp) {
    Response::error('Email and OTP are required.', 400);
}

try {
    $db = Database::getInstance();
    
    $record = $db->fetch("SELECT * FROM email_verifications WHERE email = ?", [$email]);
    
    if (!$record) {
        Response::error('No pending verification found for this email.', 404);
    }
    
    // Check 15-minute block
    if ((int)$record['verify_attempts'] >= 5) {
        $lastAttempt = strtotime($record['updated_at']);
        $now = time();
        if (($now - $lastAttempt) < (15 * 60)) {
            $remaining = ceil((15 * 60 - ($now - $lastAttempt)) / 60);
            Response::error("Too many failed attempts. Please try again in {$remaining} minutes.", 429);
        } else {
            // Block time passed, reset attempts
            $db->query("UPDATE email_verifications SET verify_attempts = 0 WHERE id = ?", [$record['id']]);
            $record['verify_attempts'] = 0;
        }
    }
    
    // Check expiry
    if (strtotime($record['expires_at']) < time()) {
        Response::error('OTP has expired. Please request a new one.', 400);
    }
    
    $hashedInputOtp = Token::hashOTP($otp);
    
    if (hash_equals($record['otp_hash'], $hashedInputOtp)) {
        // Correct OTP
        $db->query("UPDATE email_verifications SET is_verified = 1, updated_at = NOW() WHERE id = ?", [$record['id']]);
        
        // Generate Registration Token
        $regToken = Token::generateRegistrationToken();
        $hashedRegToken = Token::hashRegistrationToken($regToken);
        $uuid = Token::generateUUID();
        
        $db->query(
            "INSERT INTO registration_tokens (uuid, email, token_hash, expires_at, is_used, created_at, updated_at) 
             VALUES (?, ?, ?, DATE_ADD(NOW(), INTERVAL 24 HOUR), 0, NOW(), NOW())",
            [$uuid, $email, $hashedRegToken]
        );
        
        Response::success('OTP verified successfully.', [
            'registration_token' => $regToken
        ]);
        
    } else {
        // Incorrect OTP
        $attempts = (int)$record['verify_attempts'] + 1;
        $db->query("UPDATE email_verifications SET verify_attempts = ?, updated_at = NOW() WHERE id = ?", [$attempts, $record['id']]);
        Response::error('Incorrect OTP.', 400);
    }
    
} catch (\Exception $e) {
    Response::error('An unexpected error occurred.', 500, ['error' => $e->getMessage()]);
}
