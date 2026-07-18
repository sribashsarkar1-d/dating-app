<?php
require_once __DIR__ . '/../helper/Response.php';
require_once __DIR__ . '/../services/MasterDataService.php';

use Api\Helper\Response;
use Api\Services\MasterDataService;

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    Response::error('Method not allowed', 405);
}

try {
    $service = new MasterDataService();
    $data = $service->getAllMasterData();
    
    Response::success('Master data loaded successfully', $data, 200);
} catch (\Exception $e) {
    Response::error('Failed to load master data: ' . $e->getMessage(), 500);
}
