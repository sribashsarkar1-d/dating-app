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
$email = Validator::sanitizeEmail($input['email'] ?? '');
$token = Validator::sanitizeString($input['token'] ?? '');
$password = $input['password'] ?? '';

if (!$email || !$token || !$password) {
    Response::error('Email, token, and new password are required.', 400);
}

if (strlen($password) < 6) {
    Response::error('Password must be at least 6 characters long.', 400);
}

try {
    $db = Database::getInstance();
    
    // Get user
    $user = $db->fetch("SELECT id, status FROM users WHERE email = ? LIMIT 1", [$email]);
    if (!$user) {
        Response::error('User not found.', 404);
    }
    
    $userId = $user['id'];
    
    // Hash the provided token (uuid in the link) to compare with code_hash
    $tokenHash = Token::hashOTP($token);
    
    // Find valid OTP record
    $otpRecord = $db->fetch(
        "SELECT * FROM otps WHERE user_id = ? AND identifier = ? AND type = 'PASSWORD_RESET' AND is_used = 0 ORDER BY created_at DESC LIMIT 1",
        [$userId, $email]
    );

    if (!$otpRecord) {
        Response::error('Invalid or expired password reset link.', 400);
    }

    if (strtotime($otpRecord['expires_at']) < time()) {
        Response::error('Password reset link has expired. Please request a new one.', 400);
    }
    
    if (!hash_equals($otpRecord['code_hash'], $tokenHash)) {
        Response::error('Invalid token.', 400);
    }
    
    // Check if auth record exists
    $authRecord = $db->fetch("SELECT id FROM user_authentications WHERE user_id = ? AND auth_provider = 'PASSWORD' LIMIT 1", [$userId]);
    
    $passwordHash = password_hash($password, PASSWORD_BCRYPT);
    
    if ($authRecord) {
        $db->query("UPDATE user_authentications SET password_hash = ?, updated_at = NOW() WHERE id = ?", [$passwordHash, $authRecord['id']]);
    } else {
        $authUuid = Token::generateUUID();
        $db->query(
            "INSERT INTO user_authentications (uuid, user_id, auth_provider, password_hash, created_at, updated_at) VALUES (?, ?, 'PASSWORD', ?, NOW(), NOW())",
            [$authUuid, $userId, $passwordHash]
        );
    }
    
    // Mark token as used
    $db->query("UPDATE otps SET is_used = 1, updated_at = NOW() WHERE id = ?", [$otpRecord['id']]);
    
    Response::success('Password has been successfully reset.');
    
} catch (\Exception $e) {
    Response::error('Internal Server Error: ' . $e->getMessage(), 500);
}
