<?php
require_once __DIR__ . '/helper/Database.php';
require_once __DIR__ . '/helper/Response.php';
require_once __DIR__ . '/helper/Validator.php';
require_once __DIR__ . '/helper/Token.php';

use Api\Helper\Database;
use Api\Helper\Response;
use Api\Helper\Validator;
use Api\Helper\Token;

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    Response::error('Method not allowed', 405);
}

try {
    $input = json_decode(file_get_contents('php://input'), true) ?? $_POST;
    
    $promptText = Validator::sanitizeString($input['prompt_text'] ?? '');
    
    if (!$promptText) {
        Response::error('prompt_text is required.', 400);
    }
    
    $db = Database::getInstance();
    
    // Check for duplicate
    $exists = $db->fetch("SELECT id FROM `profile_prompts` WHERE prompt_text = ? AND deleted_at IS NULL", [$promptText]);
    if ($exists) {
        Response::error('This profile prompt already exists.', 400);
    }
    
    $uuid = Token::generateUUID();
    
    $db->query("INSERT INTO `profile_prompts` (uuid, prompt_text, created_at) VALUES (?, ?, NOW())", [$uuid, $promptText]);
    $newId = $db->getConnection()->lastInsertId();
    
    Response::success('Profile prompt added successfully.', [
        'id' => $newId,
        'prompt_text' => $promptText
    ], 201);
    
} catch (\Exception $e) {
    Response::error('An error occurred: ' . $e->getMessage(), 500);
}
