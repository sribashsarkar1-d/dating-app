<?php
require_once __DIR__ . '/../helper/Database.php';

use Api\Helper\Database;

$db = Database::getInstance();
$conn = $db->getConnection();

echo "Starting migrations...\n";

// 1. Create and Seed show_me
$conn->exec("
    CREATE TABLE IF NOT EXISTS `show_me` (
      `id` int NOT NULL AUTO_INCREMENT,
      `name` varchar(255) NOT NULL,
      `display_order` int DEFAULT '0',
      `status` enum('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
      `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
      `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
");

$show_me = $db->fetchAll("SELECT * FROM show_me LIMIT 1");
if (empty($show_me)) {
    $conn->exec("INSERT INTO `show_me` (`name`, `display_order`) VALUES
    ('Women', 1),
    ('Men', 2),
    ('Everyone', 3);");
    echo "Seeded show_me.\n";
}

// 2. Create and Seed opening_moves
$conn->exec("
    CREATE TABLE IF NOT EXISTS `opening_moves` (
      `id` int NOT NULL AUTO_INCREMENT,
      `name` varchar(500) NOT NULL,
      `display_order` int DEFAULT '0',
      `status` enum('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
      `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
      `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
");

$opening = $db->fetchAll("SELECT * FROM opening_moves LIMIT 1");
if (empty($opening)) {
    $conn->exec("INSERT INTO `opening_moves` (`name`, `display_order`) VALUES
    ('What\'s a controversial opinion you have?', 1),
    ('Two truths and a lie...', 2),
    ('Best travel story?', 3),
    ('What are you binge watching right now?', 4);");
    echo "Seeded opening_moves.\n";
}

// 3. Create and Seed zodiac_signs
$conn->exec("
    CREATE TABLE IF NOT EXISTS `zodiac_signs` (
      `id` int NOT NULL AUTO_INCREMENT,
      `name` varchar(255) NOT NULL,
      `display_order` int DEFAULT '0',
      `status` enum('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
      `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
      `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
");

$zodiac = $db->fetchAll("SELECT * FROM zodiac_signs LIMIT 1");
if (empty($zodiac)) {
    $conn->exec("INSERT INTO `zodiac_signs` (`name`, `display_order`) VALUES
    ('Aries', 1), ('Taurus', 2), ('Gemini', 3), ('Cancer', 4),
    ('Leo', 5), ('Virgo', 6), ('Libra', 7), ('Scorpio', 8),
    ('Sagittarius', 9), ('Capricorn', 10), ('Aquarius', 11), ('Pisces', 12);");
    echo "Seeded zodiac_signs.\n";
}

echo "Migrations completed.\n";
