<?php
namespace Api\Helper;

require_once __DIR__ . '/Response.php';
require_once __DIR__ . '/Token.php';

class Auth {
    public static function authenticate() {
        $headers = apache_request_headers();
        $authHeader = $headers['Authorization'] ?? $headers['authorization'] ?? '';
        
        $token = '';
        if (preg_match('/Bearer\s(\S+)/', $authHeader, $matches)) {
            $token = $matches[1];
        }

        if (!$token) {
            Response::error('Authentication token is missing.', 401);
        }

        $payload = Token::verifyAuthToken($token);

        if (!$payload || !isset($payload['user_id'])) {
            Response::error('Invalid or expired token.', 401);
        }

        return $payload['user_id'];
    }
}
