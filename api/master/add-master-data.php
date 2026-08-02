<?php
require_once __DIR__ . '/../helper/Database.php';
require_once __DIR__ . '/../helper/Response.php';
require_once __DIR__ . '/../helper/Validator.php';
require_once __DIR__ . '/../services/MasterDataService.php';

use Api\Helper\Database;
use Api\Helper\Response;
use Api\Helper\Validator;
use Api\Services\MasterDataService;

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    Response::error('Method not allowed', 405);
}

try {
    $input = json_decode(file_get_contents('php://input'), true) ?? $_POST;
    
    $category = Validator::sanitizeString($input['category'] ?? '');
    $name = Validator::sanitizeString($input['name'] ?? '');
    
    if (!$category || !$name) {
        Response::error('Category and name are required.', 400);
    }
    
    $tableMappings = [
        'genders' => 'genders',
        'show_me' => 'show_me',
        'relationship_goals' => 'relationship_goals',
        'languages' => 'languages',
        'education_levels' => 'education_levels',
        'smoking_habits' => 'smoking_habits',
        'drinking_habits' => 'drinking_habits',
        'fitness_levels' => 'fitness_habits',
        'sleep_schedules' => 'sleep_habits',
        'dietary_preferences' => 'diets',
        'family_plans' => 'children_plans',
        'pet_preferences' => 'pets',
        'communication_styles' => 'communication_styles',
        'love_languages' => 'love_languages',
        'religions' => 'religions',
        'political_views' => 'political_views',
        'interests' => 'interests',
        'countries' => 'countries',
        'states' => 'states',
        'cities' => 'cities',
        'zodiac_signs' => 'zodiac_signs'
    ];
    
    if (!isset($tableMappings[$category])) {
        Response::error('Invalid category.', 400);
    }
    
    $tableName = $tableMappings[$category];
    
    $db = Database::getInstance();
    
    // Check for duplicate
    $exists = $db->fetch("SELECT id FROM `$tableName` WHERE name = ?", [$name]);
    if ($exists) {
        Response::error('An entry with this name already exists in this category.', 400);
    }
    
    // Insert new record
    // Using a generic insert since most tables share this schema. Missing columns use default values.
    $db->query("INSERT INTO `$tableName` (name) VALUES (?)", [$name]);
    
    $newId = $db->getConnection()->lastInsertId();
    
    // Clear the cache
    $service = new MasterDataService();
    $service->clearCache();
    
    Response::success('Master data added successfully.', [
        'id' => $newId,
        'category' => $category,
        'name' => $name
    ], 201);
    
} catch (\Exception $e) {
    Response::error('An error occurred: ' . $e->getMessage(), 500);
}
