<?php
require_once __DIR__ . '/../helper/Database.php';
require_once __DIR__ . '/../helper/Response.php';
require_once __DIR__ . '/../helper/Auth.php';
require_once __DIR__ . '/../services/ExploreService.php';

use Api\Helper\Database;
use Api\Helper\Response;
use Api\Helper\Auth;
use Api\Services\ExploreService;

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

try {
    $userId = Auth::authenticate();
    $db = Database::getInstance();
    
    $baseQuery = ExploreService::getBaseExploreQuery($userId);
    $today = date('Y-m-d');
    
    $picksQuery = "SELECT target_user_id FROM user_daily_picks WHERE user_id = ? AND DATE(created_at) = ?";
    $existingPicks = $db->fetchAll($picksQuery, [$userId, $today]);
    
    if (empty($existingPicks)) {
        // Generate 10 new picks for today
        $newPicks = $db->fetchAll("SELECT id FROM ($baseQuery) as base_users ORDER BY RAND() LIMIT 10");
        foreach ($newPicks as $pick) {
            $db->execute("INSERT INTO user_daily_picks (user_id, target_user_id, created_at) VALUES (?, ?, NOW())", [$userId, $pick['id']]);
        }
        $existingPicks = $db->fetchAll($picksQuery, [$userId, $today]);
    }
    
    $result = [];
    if (!empty($existingPicks)) {
        $pickIds = array_column($existingPicks, 'target_user_id');
        $pickIdsStr = implode(',', $pickIds);
        
        $users = $db->fetchAll("SELECT * FROM ($baseQuery) as base_users WHERE id IN ($pickIdsStr)");
        
        foreach ($users as $u) {
            $result[] = ExploreService::formatUserResponse($u, $db);
        }
    }
    
    Response::success('Daily picks fetched successfully', [
        'users' => $result
    ], 200);

} catch (\Exception $e) {
    Response::error('An error occurred.', 500, ['error' => $e->getMessage()]);
}
