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
    
    $page = isset($_GET['page']) ? max(1, (int)$_GET['page']) : 1;
    $limit = isset($_GET['limit']) ? max(1, (int)$_GET['limit']) : 20;
    $offset = ($page - 1) * $limit;
    
    $baseQuery = ExploreService::getBaseExploreQuery($userId);
    
    // Get current user profile for compatibility matching
    $currentUserProfile = $db->fetch("SELECT * FROM users u JOIN user_profiles up ON u.id = up.user_id WHERE u.id = ?", [$userId]);
    
    // We just fetch users and compute score
    $query = "
        SELECT * FROM ($baseQuery) as base_users
        ORDER BY RAND() -- A real app would use a model score column, we use random for base list
        LIMIT $limit OFFSET $offset
    ";
    
    $users = $db->fetchAll($query);
    
    $result = [];
    foreach ($users as $u) {
        $comp = RecommendationService::generateCompatibility($currentUserProfile, $u);
        $u['compatibility'] = $comp['score'];
        $u['compatibility_reason'] = $comp['reason'];
        $result[] = ExploreService::formatUserResponse($u, $db);
    }
    
    // Sort by compatibility descending (as we generated it in PHP)
    usort($result, function($a, $b) {
        return (int)$b['compatibility'] <=> (int)$a['compatibility'];
    });
    
    Response::success('Recommended users fetched successfully', [
        'users' => $result
    ], 200);

} catch (\Exception $e) {
    Response::error('An error occurred.', 500, ['error' => $e->getMessage()]);
}
