<?php
require_once __DIR__ . '/../helper/Database.php';
require_once __DIR__ . '/../helper/Response.php';
require_once __DIR__ . '/../helper/Auth.php';

use Api\Helper\Database;
use Api\Helper\Response;
use Api\Helper\Auth;

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

try {
    Auth::authenticate(); // Verify token
    $db = Database::getInstance();
    
    $interests = $db->fetchAll("SELECT name, icon FROM explore_interests ORDER BY sort_order ASC");
    
    Response::success('Interests fetched successfully', [
        'categories' => $interests
    ], 200);

} catch (\Exception $e) {
    Response::error('An error occurred.', 500, ['error' => $e->getMessage()]);
}
