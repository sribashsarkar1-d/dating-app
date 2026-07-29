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
    
    $page = isset($_GET['page']) ? max(1, (int)$_GET['page']) : 1;
    $limit = isset($_GET['limit']) ? max(1, (int)$_GET['limit']) : 20;
    $offset = ($page - 1) * $limit;
    
    $baseQuery = ExploreService::getBaseExploreQuery($userId);
    
    $query = "
        SELECT * FROM ($baseQuery) as base_users
        WHERE is_verified = 1
        ORDER BY id DESC
        LIMIT $limit OFFSET $offset
    ";
    
    $users = $db->fetchAll($query);
    
    $result = [];
    foreach ($users as $u) {
        $result[] = ExploreService::formatUserResponse($u, $db);
    }
    
    Response::success('Verified users fetched successfully', [
        'users' => $result
    ], 200);

} catch (\Exception $e) {
    Response::error('An error occurred.', 500, ['error' => $e->getMessage()]);
}
