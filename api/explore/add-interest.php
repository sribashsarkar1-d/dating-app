<?php
require_once __DIR__ . '/../helper/Database.php';
require_once __DIR__ . '/../helper/Response.php';
require_once __DIR__ . '/../helper/Validator.php';

use Api\Helper\Database;
use Api\Helper\Response;
use Api\Helper\Validator;

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    Response::error('Method not allowed', 405);
}

try {
    $input = json_decode(file_get_contents('php://input'), true) ?? $_POST;
    
    $name = Validator::sanitizeString($input['name'] ?? '');
    $icon = Validator::sanitizeString($input['icon'] ?? '');
    
    if (!$name) {
        Response::error('name is required.', 400);
    }
    
    $db = Database::getInstance();
    
    // Check for duplicate
    $exists = $db->fetch("SELECT id FROM `explore_interests` WHERE name = ?", [$name]);
    if ($exists) {
        Response::error('This interest already exists.', 400);
    }
    
    // Get max sort order
    $maxOrderRow = $db->fetch("SELECT MAX(sort_order) as max_order FROM `explore_interests`");
    $sortOrder = $maxOrderRow ? ((int)$maxOrderRow['max_order'] + 1) : 1;
    
    $db->query("INSERT INTO `explore_interests` (name, icon, sort_order) VALUES (?, ?, ?)", [$name, $icon, $sortOrder]);
    $newId = $db->getConnection()->lastInsertId();
    
    Response::success('Interest added successfully.', [
        'id' => $newId,
        'name' => $name,
        'icon' => $icon,
        'sort_order' => $sortOrder
    ], 201);
    
} catch (\Exception $e) {
    Response::error('An error occurred: ' . $e->getMessage(), 500);
}
