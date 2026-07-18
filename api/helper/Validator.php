<?php
namespace Api\Helper;

class Validator {
    public static function sanitizeString($input) {
        if ($input === null) return null;
        return htmlspecialchars(strip_tags(trim($input)), ENT_QUOTES, 'UTF-8');
    }

    public static function sanitizeEmail($email) {
        if ($email === null) return null;
        return filter_var(trim($email), FILTER_SANITIZE_EMAIL);
    }

    public static function isValidEmail($email) {
        return filter_var($email, FILTER_VALIDATE_EMAIL) !== false;
    }
    
    public static function getAgeFromDob($dob) {
        if (!$dob || !strtotime($dob)) return 0;
        $birthDate = new \DateTime($dob);
        $today = new \DateTime('today');
        return $birthDate->diff($today)->y;
    }
}
