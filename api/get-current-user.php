<?php
require_once __DIR__ . '/helper/Database.php';
require_once __DIR__ . '/helper/Response.php';
require_once __DIR__ . '/helper/Auth.php';

use Api\Helper\Database;
use Api\Helper\Response;
use Api\Helper\Auth;

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    Response::error('Method not allowed', 405);
}

try {
    // Middleware: Verifies token and returns user_id
    $userId = Auth::authenticate();

    $db = Database::getInstance();

    // Fetch user basic data and profile
    $userQuery = "
        SELECT 
            u.id, u.uuid, u.first_name, u.last_name, u.display_name, u.email, u.phone, 
            u.birth_date, u.age, u.status, u.onboarding_completed,
            g.name as gender_identity,
            p.bio, p.height_cm, p.weight_kg, p.hometown, p.compatibility_score_base, p.is_verified
        FROM users u
        LEFT JOIN user_profiles p ON u.id = p.user_id
        LEFT JOIN genders g ON u.gender_identity_id = g.id
        WHERE u.id = ? AND (u.status = 'ACTIVE' OR u.status = 'PENDING_VERIFICATION')
        LIMIT 1
    ";
    
    $user = $db->fetch($userQuery, [$userId]);

    if (!$user) {
        Response::error('User not found or account is inactive.', 404);
    }

    // Fetch user photos
    $photosQuery = "
        SELECT id, uuid, photo_url, is_main, display_order, is_verified_photo 
        FROM user_photos 
        WHERE user_id = ? 
        ORDER BY display_order ASC, is_main DESC
    ";
    
    $photos = $db->fetchAll($photosQuery, [$userId]);
    
    $user['photos'] = $photos;

    // We can also fetch lifestyle/preferences here by joining more tables, 
    // but this gives a solid complete profile for the current user.

    Response::success('Current user profile fetched successfully.', $user);

} catch (\Exception $e) {
    Response::error('Internal Server Error: ' . $e->getMessage(), 500);
}
