<?php
require_once __DIR__ . '/../helper/Database.php';
require_once __DIR__ . '/../helper/Response.php';
require_once __DIR__ . '/../helper/Auth.php';
require_once __DIR__ . '/../services/ExploreService.php';
require_once __DIR__ . '/../services/DistanceService.php';
require_once __DIR__ . '/../services/RecommendationService.php';

use Api\Helper\Database;
use Api\Helper\Response;
use Api\Helper\Auth;
use Api\Services\ExploreService;
use Api\Services\DistanceService;
use Api\Services\RecommendationService;

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

try {
    $userId = Auth::authenticate();
    $db = Database::getInstance();
    
    $baseQuery = ExploreService::getBaseExploreQuery($userId);
    
    $data = [
        'nearby' => [],
        'recommendations' => [],
        'online' => [],
        'verified' => [],
        'premium' => [],
        'new_members' => [],
        'popular' => [],
        'daily_picks' => [],
        'interests' => [],
        'trending' => []
    ];

    // Helper to fetch and format limited users
    $fetchUsers = function($query) use ($db) {
        $users = $db->fetchAll($query);
        $result = [];
        foreach ($users as $u) {
            $result[] = ExploreService::formatUserResponse($u, $db);
        }
        return $result;
    };

    // 1. Nearby (requires lat/long, we'll try to get from profile)
    $userLoc = $db->fetch("SELECT base_latitude, base_longitude FROM user_profiles WHERE user_id = ?", [$userId]);
    if ($userLoc && $userLoc['base_latitude']) {
        $lat = $userLoc['base_latitude'];
        $lng = $userLoc['base_longitude'];
        $haversine = \Api\Services\DistanceService::getHaversineSQL('base_latitude', 'base_longitude', $lat, $lng);
        $query = "SELECT *, ($haversine) as distance FROM ($baseQuery) as base_users HAVING distance <= 50 ORDER BY distance ASC LIMIT 10";
        $data['nearby'] = $fetchUsers($query);
    }

    // 2. Online
    $data['online'] = $fetchUsers("SELECT * FROM ($baseQuery) as base_users WHERE last_seen >= (NOW() - INTERVAL 5 MINUTE) ORDER BY last_seen DESC LIMIT 10");

    // 3. Verified
    $data['verified'] = $fetchUsers("SELECT * FROM ($baseQuery) as base_users WHERE is_verified = 1 ORDER BY id DESC LIMIT 10");

    // 4. Premium
    $data['premium'] = $fetchUsers("SELECT * FROM ($baseQuery) as base_users WHERE is_premium = 1 ORDER BY id DESC LIMIT 10");

    // 5. New Members
    $data['new_members'] = $fetchUsers("SELECT * FROM ($baseQuery) as base_users WHERE id IN (SELECT id FROM users WHERE created_at >= (NOW() - INTERVAL 30 DAY)) ORDER BY id DESC LIMIT 10");
    
    // 6. Popular
    $data['popular'] = $fetchUsers("
        SELECT bu.*, (SELECT COUNT(*) FROM user_views WHERE user_id = bu.id) as views
        FROM ($baseQuery) as bu 
        ORDER BY views DESC LIMIT 10
    ");

    // 7. Daily Picks
    // Check if daily picks exist for today
    $today = date('Y-m-d');
    $picksQuery = "SELECT target_user_id FROM user_daily_picks WHERE user_id = ? AND DATE(created_at) = ?";
    $existingPicks = $db->fetchAll($picksQuery, [$userId, $today]);
    
    if (empty($existingPicks)) {
        // Generate new picks
        $newPicks = $db->fetchAll("SELECT id FROM ($baseQuery) as base_users ORDER BY RAND() LIMIT 10");
        foreach ($newPicks as $pick) {
            $db->query("INSERT INTO user_daily_picks (user_id, target_user_id, created_at) VALUES (?, ?, NOW())", [$userId, $pick['id']]);
        }
        $existingPicks = $db->fetchAll($picksQuery, [$userId, $today]);
    }
    
    if (!empty($existingPicks)) {
        $pickIds = array_column($existingPicks, 'target_user_id');
        $pickIdsStr = implode(',', $pickIds);
        $data['daily_picks'] = $fetchUsers("SELECT * FROM ($baseQuery) as base_users WHERE id IN ($pickIdsStr) LIMIT 10");
    }

    // 8. Recommendations
    // For simplicity in home API, get random users and calculate score
    $recUsers = $db->fetchAll("SELECT * FROM ($baseQuery) as base_users ORDER BY RAND() LIMIT 10");
    $currentUserProfile = $db->fetch("SELECT * FROM users u JOIN user_profiles up ON u.id = up.user_id WHERE u.id = ?", [$userId]);
    foreach ($recUsers as $u) {
        $comp = \Api\Services\RecommendationService::generateCompatibility($currentUserProfile, $u);
        $u['compatibility'] = $comp['score'];
        $u['compatibility_reason'] = $comp['reason'];
        $data['recommendations'][] = ExploreService::formatUserResponse($u, $db);
    }

    // 9. Interests
    $data['interests'] = $db->fetchAll("SELECT name, icon FROM explore_interests ORDER BY sort_order ASC");

    // 10. Trending
    $data['trending'] = $db->fetchAll("SELECT name, image_url FROM explore_trending_categories ORDER BY sort_order ASC");
    
    Response::success('Explore home fetched successfully', $data, 200);

} catch (\Exception $e) {
    Response::error('An error occurred.', 500, ['error' => $e->getMessage()]);
}
