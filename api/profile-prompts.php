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
    $prompts = $db->fetchAll("SELECT id, prompt_text as question FROM profile_prompts WHERE deleted_at IS NULL ORDER BY id ASC");
    
    // Formatting data as expected by the prompt
    $data = [];
    foreach ($prompts as $prompt) {
        $data[] = [
            'id' => (int)$prompt['id'],
            'question' => $prompt['question']
        ];
    }
    
    echo json_encode([
        'status' => true,
        'data' => $data
    ]);
} catch (\Exception $e) {
    Response::error('Internal Server Error', 500);
}
