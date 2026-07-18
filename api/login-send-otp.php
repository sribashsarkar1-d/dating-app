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
$email = Validator::sanitizeEmail($input['email'] ?? '');

if (!$email || !Validator::isValidEmail($email)) {
    Response::error('Valid email address is required.', 400);
}

try {
    $db = Database::getInstance();
    
    // Check if user exists
    $user = $db->fetch("SELECT id, status FROM users WHERE email = ? LIMIT 1", [$email]);
    
    if (!$user) {
        Response::error('User not found. Please register first.', 404);
    }
    
    if ($user['status'] === 'BANNED' || $user['status'] === 'DELETED') {
        Response::error('Your account is ' . strtolower($user['status']) . '.', 403);
    }
    
    $userId = $user['id'];

    // Invalidate old pending login OTPs for this user
    $db->query("UPDATE otps SET is_used = 1 WHERE user_id = ? AND type = 'LOGIN' AND is_used = 0", [$userId]);

    // Generate new OTP
    $otp = Token::generateOTP();
    $otpHash = Token::hashOTP($otp);
    $expiresAt = date('Y-m-d H:i:s', time() + (10 * 60)); // 10 mins expiry

    $db->query(
        "INSERT INTO otps (user_id, type, identifier, code_hash, expires_at, created_at, updated_at) VALUES (?, 'LOGIN', ?, ?, ?, NOW(), NOW())",
        [$userId, $email, $otpHash, $expiresAt]
    );

    // Send email
    $time = date('H:i:s');
    $mailer = new Mailer();
    $subject = "Your Login OTP - Dating App ({$time})";
    $body = "<h2>Login Verification</h2>
             <p>Your OTP for login is: <strong>{$otp}</strong></p>
             <p>This OTP will expire in 10 minutes. Do not share it with anyone.</p>";

    if ($mailer->sendMail($email, $subject, $body)) {
        Response::success('Login OTP sent successfully to your email.');
    } else {
        Response::error('Failed to send OTP email. Please try again later.', 500);
    }
} catch (\Exception $e) {
    Response::error('Internal Server Error: ' . $e->getMessage(), 500);
}
