<?php
require_once __DIR__ . '/../helper/Database.php';
require_once __DIR__ . '/../helper/Response.php';
require_once __DIR__ . '/../helper/Auth.php';
require_once __DIR__ . '/../services/ExploreService.php';
require_once __DIR__ . '/../services/RecommendationService.php';

use Api\Helper\Database;
use Api\Helper\Response;
use Api\Helper\Auth;
use Api\Services\ExploreService;
use Api\Services\RecommendationService;

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

try {
    $userId = Auth::authenticate();
    $db = Database::getInstance();
    
    $targetId = isset($_GET['id']) ? (int)$_GET['id'] : 0;
    
    if (!$targetId) {
        Response::error('User ID is required.', 400);
    }
    
    if ($userId == $targetId) {
        Response::error('Cannot view own profile in explore mode.', 400);
    }
    
    // Check if blocked or etc.
    $excludeInteractions = $db->fetch("SELECT id FROM user_interactions WHERE user_id = ? AND target_user_id = ?", [$userId, $targetId]);
    if ($excludeInteractions) {
        Response::error('User not available.', 404);
    }
    
    $targetUser = $db->fetch("
        SELECT 
            u.id, u.first_name, u.birth_date, u.age, u.is_premium, u.last_seen,
            up.bio, up.height_cm, up.hometown, up.job_title, up.company, up.is_verified, 
            up.base_latitude, up.base_longitude, up.zodiac_sign, up.language_spoken, up.education_id,
            up.religion_id, up.smoking_id, up.drinking_id, up.fitness_id, up.children_id
        FROM users u
        JOIN user_profiles up ON u.id = up.user_id
        WHERE u.id = ? AND u.status = 'ACTIVE'
    ", [$targetId]);
    
    if (!$targetUser) {
        Response::error('Profile not found.', 404);
    }
    
    // Track View
    $db->execute("INSERT INTO user_views (user_id, viewer_id, created_at) VALUES (?, ?, NOW())", [$targetId, $userId]);
    
    // Get Photos
    $photos = $db->fetchAll("SELECT photo_url, is_main, display_order FROM user_photos WHERE user_id = ? ORDER BY is_main DESC, display_order ASC", [$targetId]);
    
    // Get Prompts
    $prompts = $db->fetchAll("
        SELECT p.answer, q.question 
        FROM user_profile_prompts p 
        JOIN profile_prompt_questions q ON p.question_id = q.id 
        WHERE p.user_id = ?
    ", [$targetId]);
    
    // Get Opening Moves
    $openingMoves = $db->fetchAll("
        SELECT m.answer, m.custom_question, q.question 
        FROM user_opening_moves m 
        LEFT JOIN opening_move_questions q ON m.question_id = q.id 
        WHERE m.user_id = ?
    ", [$targetId]);
    
    // Calculate Compatibility
    $currentUserProfile = $db->fetch("SELECT * FROM users u JOIN user_profiles up ON u.id = up.user_id WHERE u.id = ?", [$userId]);
    $comp = RecommendationService::generateCompatibility($currentUserProfile, $targetUser);
    
    $result = [
        'id' => (int)$targetUser['id'],
        'first_name' => $targetUser['first_name'],
        'age' => (int)$targetUser['age'],
        'is_verified' => (bool)$targetUser['is_verified'],
        'is_premium' => (bool)$targetUser['is_premium'],
        'online' => $targetUser['last_seen'] && (time() - strtotime($targetUser['last_seen'])) < 300,
        'last_seen' => $targetUser['last_seen'],
        'bio' => $targetUser['bio'],
        'height_cm' => $targetUser['height_cm'],
        'job_title' => $targetUser['job_title'],
        'company' => $targetUser['company'],
        'zodiac_sign' => $targetUser['zodiac_sign'],
        'language_spoken' => $targetUser['language_spoken'],
        'compatibility_score' => $comp['score'],
        'compatibility_reason' => $comp['reason'],
        'photos' => $photos,
        'prompts' => $prompts,
        'opening_moves' => $openingMoves
    ];
    
    Response::success('Profile fetched successfully', ['profile' => $result], 200);

} catch (\Exception $e) {
    Response::error('An error occurred.', 500, ['error' => $e->getMessage()]);
}
