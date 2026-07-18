<?php
require 'api/helper/Database.php';
$db = \Api\Helper\Database::getInstance();
$tables = $db->fetchAll("SHOW TABLES");
foreach ($tables as $t) {
    echo array_values($t)[0] . "\n";
}
