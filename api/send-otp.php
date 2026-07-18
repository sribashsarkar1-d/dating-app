<?php
require_once __DIR__ . '/helper/Database.php';
require_once __DIR__ . '/helper/Response.php';
require_once __DIR__ . '/helper/Validator.php';
require_once __DIR__ . '/helper/Token.php';
require_once __DIR__ . '/mail/Mailer.php';

use Api\Helper\Database;
use Api\Helper\Response;
use Api\Helper\Validator;
use Api\Helper\Token;
use Api\Mail\Mailer;

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    Response::error('Method not allowed', 405);
}

$input = json_decode(file_get_contents('php://input'), true) ?? $_POST;
$email = Validator::sanitizeEmail($input['email'] ?? null);

if (!$email || !Validator::isValidEmail($email)) {
    Response::error('Invalid email address provided.', 400);
}

try {
    $db = Database::getInstance();
    
    // Check for duplicate registration
    $user = $db->fetch("SELECT id FROM users WHERE email = ?", [$email]);
    if ($user) {
        Response::error('Email is already registered.', 409);
    }
    
    $otp = Token::generateOTP(6);
    $hashedOtp = Token::hashOTP($otp);
    
    // Invalidate old OTP by deleting existing verifications for this email
    $db->query("DELETE FROM email_verifications WHERE email = ?", [$email]);
    
    $uuid = Token::generateUUID();
    $expiresAt = date('Y-m-d H:i:s', strtotime('+5 minutes'));
    
    $db->query(
        "INSERT INTO email_verifications (uuid, email, otp_hash, verify_attempts, resend_attempts, expires_at, is_verified, created_at, updated_at) 
         VALUES (?, ?, ?, 0, 0, ?, 0, NOW(), NOW())",
        [$uuid, $email, $hashedOtp, $expiresAt]
    );
    
    $mailer = new Mailer();
    if ($mailer->sendOTP($email, $otp)) {
        Response::success('OTP sent successfully to your email.', null, 200);
    } else {
        // If mail fails, delete the OTP to avoid locking the user out
        $db->query("DELETE FROM email_verifications WHERE uuid = ?", [$uuid]);
        Response::error('Failed to send OTP email. Please try again later.', 500);
    }
} catch (\Exception $e) {
    Response::error('An unexpected error occurred.', 500, ['error' => $e->getMessage()]);
}
