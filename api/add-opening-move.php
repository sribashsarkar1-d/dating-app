<?php
require_once __DIR__ . '/helper/Database.php';
require_once __DIR__ . '/helper/Response.php';
require_once __DIR__ . '/helper/Validator.php';

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
    
    if (!$name) {
        Response::error('name is required.', 400);
    }
    
    $db = Database::getInstance();
    
    // Check for duplicate
    $exists = $db->fetch("SELECT id FROM `opening_moves` WHERE name = ?", [$name]);
    if ($exists) {
        Response::error('This opening move already exists.', 400);
    }
    
    // Get max display order
    $maxOrderRow = $db->fetch("SELECT MAX(display_order) as max_order FROM `opening_moves`");
    $displayOrder = $maxOrderRow ? ((int)$maxOrderRow['max_order'] + 1) : 1;
    
    $db->query("INSERT INTO `opening_moves` (name, display_order, status, created_at) VALUES (?, ?, 'ACTIVE', NOW())", [$name, $displayOrder]);
    $newId = $db->getConnection()->lastInsertId();
    
    Response::success('Opening move added successfully.', [
        'id' => $newId,
        'name' => $name,
        'display_order' => $displayOrder
    ], 201);
    
} catch (\Exception $e) {
    Response::error('An error occurred: ' . $e->getMessage(), 500);
}
