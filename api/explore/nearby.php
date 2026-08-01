<?php
require_once __DIR__ . '/../helper/Database.php';
require_once __DIR__ . '/../helper/Response.php';
require_once __DIR__ . '/../helper/Auth.php';
require_once __DIR__ . '/../services/ExploreService.php';
require_once __DIR__ . '/../services/DistanceService.php';

use Api\Helper\Database;
use Api\Helper\Response;
use Api\Helper\Auth;
use Api\Services\ExploreService;
use Api\Services\DistanceService;

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

try {
    $userId = Auth::authenticate();
    $db = Database::getInstance();
    
    // Get pagination
    $page = isset($_GET['page']) ? max(1, (int)$_GET['page']) : 1;
    $limit = isset($_GET['limit']) ? max(1, (int)$_GET['limit']) : 20;
    $offset = ($page - 1) * $limit;
    
    // Get parameters
    $lat = $_GET['latitude'] ?? null;
    $lng = $_GET['longitude'] ?? null;
    $maxDistance = isset($_GET['distance']) ? (int)$_GET['distance'] : 50; // default 50km
    
    if (!$lat || !$lng) {
        // Fallback to user's saved location
        $userLoc = $db->fetch("SELECT base_latitude, base_longitude FROM user_profiles WHERE user_id = ?", [$userId]);
        if (!$userLoc || !$userLoc['base_latitude']) {
            Response::error('Latitude and Longitude are required.', 400);
        }
        $lat = $userLoc['base_latitude'];
        $lng = $userLoc['base_longitude'];
    }

    $haversine = DistanceService::getHaversineSQL('base_latitude', 'base_longitude', $lat, $lng);
    $baseQuery = ExploreService::getBaseExploreQuery($userId);
    
    // Build final query
    $query = "
        SELECT *, ($haversine) as distance
        FROM ($baseQuery) as base_users
        HAVING distance <= $maxDistance
        ORDER BY distance ASC
        LIMIT $limit OFFSET $offset
    ";
    
    $users = $db->fetchAll($query);
    
    $result = [];
    foreach ($users as $u) {
        $result[] = ExploreService::formatUserResponse($u, $db);
    }
    
    // Pagination logic
    $totalQuery = "SELECT COUNT(*) as total FROM ($baseQuery) as base_users WHERE ($haversine) <= $maxDistance";
    $totalCount = $db->fetch($totalQuery)['total'] ?? 0;
    
    Response::success('Nearby users fetched successfully', [
        'users' => $result
    ], 200);

} catch (\Exception $e) {
    Response::error('An error occurred.', 500, ['error' => $e->getMessage()]);
}
