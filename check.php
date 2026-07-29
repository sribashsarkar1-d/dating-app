<?php
require_once __DIR__ . '/api/helper/Database.php';
$db = Api\Helper\Database::getInstance();
$stmt = $db->query("DESCRIBE otps");
$result = $stmt->fetchAll(PDO::FETCH_ASSOC);
print_r($result);
