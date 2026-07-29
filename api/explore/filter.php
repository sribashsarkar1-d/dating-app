<?php
require_once __DIR__ . '/../helper/Database.php';
require_once __DIR__ . '/../helper/Response.php';
require_once __DIR__ . '/../helper/Auth.php';
require_once __DIR__ . '/../services/ExploreService.php';
require_once __DIR__ . '/../services/FilterService.php';

use Api\Helper\Database;
use Api\Helper\Response;
use Api\Helper\Auth;
use Api\Services\ExploreService;
use Api\Services\FilterService;

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

try {
    $userId = Auth::authenticate();
    $db = Database::getInstance();
    
    $input = json_decode(file_get_contents('php://input'), true) ?? [];
    
    $page = isset($input['page']) ? max(1, (int)$input['page']) : 1;
    $limit = isset($input['limit']) ? max(1, (int)$input['limit']) : 20;
    $offset = ($page - 1) * $limit;
    
    $baseQuery = ExploreService::getBaseExploreQuery($userId);
    
    $params = [];
    $filterWhere = FilterService::buildFilterQuery($input, $params);
    
    $orderBy = "id DESC";
    if (isset($input['sort_by'])) {
        if ($input['sort_by'] == 'newest') {
            $orderBy = "id DESC";
        } else if ($input['sort_by'] == 'nearest') {
            // we need lat/lng if we want distance
        } else if ($input['sort_by'] == 'popular') {
            $orderBy = "(SELECT COUNT(*) FROM user_views WHERE user_id = base_users.id) DESC";
        }
    }
    
    $query = "
        SELECT * FROM ($baseQuery) as base_users
        WHERE 1=1 $filterWhere
        ORDER BY $orderBy
        LIMIT $limit OFFSET $offset
    ";
    
    $stmt = $db->getConnection()->prepare($query);
    $stmt->execute($params);
    $users = $stmt->fetchAll(\PDO::FETCH_ASSOC);
    
    $result = [];
    foreach ($users as $u) {
        $result[] = ExploreService::formatUserResponse($u, $db);
    }
    
    Response::success('Filtered results fetched successfully', [
        'users' => $result
    ], 200);

} catch (\Exception $e) {
    Response::error('An error occurred.', 500, ['error' => $e->getMessage()]);
}
