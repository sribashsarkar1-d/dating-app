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

    // Check cooldown to prevent spam
    $record = $db->fetch("SELECT TIMESTAMPDIFF(SECOND, updated_at, NOW()) as seconds_passed FROM otps WHERE identifier = ? AND type = 'PASSWORD_RESET' ORDER BY updated_at DESC LIMIT 1", [$email]);
    
    if ($record) {
        $secondsPassed = (int)$record['seconds_passed'];
        if ($secondsPassed < 60 && $secondsPassed >= -60) {
            $remaining = 60 - max(0, $secondsPassed);
            Response::error("Please wait {$remaining} seconds before requesting a new password reset link.", 429);
        }
    }

    // Invalidate old pending reset tokens for this user
    $db->query("UPDATE otps SET is_used = 1 WHERE user_id = ? AND type = 'PASSWORD_RESET' AND is_used = 0", [$userId]);

    // Generate new token (uuid for link)
    $token = Token::generateUUID();
    $tokenHash = Token::hashOTP($token); // We can reuse the hash function or just store hash
    $uuid = Token::generateUUID();
    $expiresAt = date('Y-m-d H:i:s', time() + (30 * 60)); // 30 mins expiry

    $db->query(
        "INSERT INTO otps (uuid, user_id, type, identifier, code_hash, expires_at, created_at, updated_at) VALUES (?, ?, 'PASSWORD_RESET', ?, ?, ?, NOW(), NOW())",
        [$uuid, $userId, $email, $tokenHash, $expiresAt]
    );

    // Normally the frontend URL should be loaded from env, let's use a generic placeholder or relative url
    // To make it easy to change later, we use a constant or just the $_SERVER vars
    $protocol = isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? "https" : "http";
    $host = $_SERVER['HTTP_HOST'] ?? 'localhost';
    
    // You may adjust this frontend link according to your frontend application routes
    $resetLink = "{$protocol}://{$host}/reset-password?token={$token}&email=" . urlencode($email);

    // Send email
    $mailer = new Mailer();
    $subject = "Password Reset Request - Dating App";
    $body = "<h2>Password Reset</h2>
             <p>You have requested to reset your password. Click the link below to reset it:</p>
             <p><a href='{$resetLink}' target='_blank'>{$resetLink}</a></p>
             <p>This link will expire in 30 minutes. If you did not request this, please ignore this email.</p>";

    if ($mailer->sendMail($email, $subject, $body)) {
        Response::success('Password reset link sent successfully to your email.');
    } else {
        Response::error('Failed to send reset email. Please try again later.', 500);
    }
} catch (\Exception $e) {
    Response::error('Internal Server Error: ' . $e->getMessage(), 500);
}
