<?php
require_once __DIR__ . '/helper/Database.php';
require_once __DIR__ . '/helper/Response.php';

use Api\Helper\Database;
use Api\Helper\Response;

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    Response::error('Method not allowed', 405);
}

try {
    $db = Database::getInstance();
    $moves = $db->fetchAll("SELECT id, question FROM opening_move_questions WHERE status = 'ACTIVE' ORDER BY sort_order ASC, id ASC");
    
    $data = [];
    foreach ($moves as $move) {
        $data[] = [
            'id' => (int)$move['id'],
            'question' => $move['question']
        ];
    }
    
    echo json_encode([
        'status' => true,
        'data' => $data
    ]);
} catch (\Exception $e) {
    Response::error('Internal Server Error', 500);
}
