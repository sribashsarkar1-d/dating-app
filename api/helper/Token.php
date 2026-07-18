<?php
namespace Api\Helper;

class Token {
    public static function generateUUID() {
        if (function_exists('random_bytes')) {
            $data = random_bytes(16);
            assert(strlen($data) == 16);
            $data[6] = chr(ord($data[6]) & 0x0f | 0x40); // set version to 0100
            $data[8] = chr(ord($data[8]) & 0x3f | 0x80); // set bits 6-7 to 10
            return vsprintf('%s%s-%s-%s-%s-%s%s%s', str_split(bin2hex($data), 4));
        }
        return sprintf('%04x%04x-%04x-%04x-%04x-%04x%04x%04x',
            mt_rand(0, 0xffff), mt_rand(0, 0xffff),
            mt_rand(0, 0xffff),
            mt_rand(0, 0x0fff) | 0x4000,
            mt_rand(0, 0x3fff) | 0x8000,
            mt_rand(0, 0xffff), mt_rand(0, 0xffff), mt_rand(0, 0xffff)
        );
    }

    public static function generateOTP($length = 6) {
        $otp = '';
        for ($i = 0; $i < $length; $i++) {
            $otp .= random_int(0, 9);
        }
        return $otp;
    }

    public static function hashOTP($otp) {
        return hash('sha256', $otp);
    }

    public static function generateRegistrationToken() {
        return bin2hex(random_bytes(32));
    }
    
    public static function hashRegistrationToken($token) {
        return hash('sha256', $token);
    }

    private static function base64UrlEncode($data) {
        return str_replace(['+', '/', '='], ['-', '_', ''], base64_encode($data));
    }

    private static function base64UrlDecode($data) {
        $padding = strlen($data) % 4;
        if ($padding > 0) {
            $data .= str_repeat('=', 4 - $padding);
        }
        return base64_decode(str_replace(['-', '_'], ['+', '/'], $data));
    }

    public static function generateAuthToken($userId) {
        $appConfig = require __DIR__ . '/../../config/app.php';
        $secret = $appConfig['jwt_secret'];
        $expiration = time() + $appConfig['jwt_expiration'];

        $header = json_encode(['typ' => 'JWT', 'alg' => 'HS256']);
        $payload = json_encode(['user_id' => $userId, 'exp' => $expiration, 'iat' => time()]);

        $base64UrlHeader = self::base64UrlEncode($header);
        $base64UrlPayload = self::base64UrlEncode($payload);

        $signature = hash_hmac('sha256', $base64UrlHeader . "." . $base64UrlPayload, $secret, true);
        $base64UrlSignature = self::base64UrlEncode($signature);

        return $base64UrlHeader . "." . $base64UrlPayload . "." . $base64UrlSignature;
    }

    public static function verifyAuthToken($token) {
        $appConfig = require __DIR__ . '/../../config/app.php';
        $secret = $appConfig['jwt_secret'];

        $parts = explode('.', $token);
        if (count($parts) !== 3) {
            return false;
        }

        list($header, $payload, $signature) = $parts;

        $validSignature = hash_hmac('sha256', $header . "." . $payload, $secret, true);
        $base64UrlValidSignature = self::base64UrlEncode($validSignature);

        if (hash_equals($base64UrlValidSignature, $signature)) {
            $payloadData = json_decode(self::base64UrlDecode($payload), true);
            if (isset($payloadData['exp']) && $payloadData['exp'] >= time()) {
                return $payloadData;
            }
        }
        
        return false;
    }
}
