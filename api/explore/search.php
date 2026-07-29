<?php
require_once __DIR__ . '/../helper/Database.php';
require_once __DIR__ . '/../helper/Response.php';
require_once __DIR__ . '/../helper/Auth.php';
require_once __DIR__ . '/../services/ExploreService.php';
require_once __DIR__ . '/../services/SearchService.php';

use Api\Helper\Database;
use Api\Helper\Response;
use Api\Helper\Auth;
use Api\Services\ExploreService;
use Api\Services\SearchService;

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

try {
    $userId = Auth::authenticate();
    $db = Database::getInstance();
    
    $page = isset($_GET['page']) ? max(1, (int)$_GET['page']) : 1;
    $limit = isset($_GET['limit']) ? max(1, (int)$_GET['limit']) : 20;
    $offset = ($page - 1) * $limit;
    
    $queryStr = $_GET['q'] ?? '';
    if (empty($queryStr)) {
        Response::error('Search query is required.', 400);
    }
    
    $baseQuery = ExploreService::getBaseExploreQuery($userId);
    $searchWhere = SearchService::getSearchWhereClause($queryStr);
    
    // We add search string to parameters
    $params = ['search' => '%' . $queryStr . '%'];
    
    $query = "
        SELECT * FROM ($baseQuery) as base_users
        WHERE 1=1 $searchWhere
        ORDER BY id DESC
        LIMIT $limit OFFSET $offset
    ";
    
    // We can't easily pass named params down into the base query safely with PDO if we mix them, 
    // so let's prepare and execute this specific search wrapper
    $stmt = $db->getConnection()->prepare($query);
    $stmt->execute($params);
    $users = $stmt->fetchAll(\PDO::FETCH_ASSOC);
    
    $result = [];
    foreach ($users as $u) {
        $result[] = ExploreService::formatUserResponse($u, $db);
    }
    
    Response::success('Search results fetched successfully', [
        'users' => $result
    ], 200);

} catch (\Exception $e) {
    Response::error('An error occurred.', 500, ['error' => $e->getMessage()]);
}
