<?php
require_once __DIR__ . '/../helper/Database.php';
use Api\Helper\Database;

try {
    $db = Database::getInstance();
    $conn = $db->getConnection();
    
    echo "Starting Explore Migration...\n";

    // 1. Alter users table
    $columns = [
        "last_seen" => "TIMESTAMP NULL DEFAULT NULL",
        "is_premium" => "TINYINT(1) DEFAULT 0"
    ];

    foreach ($columns as $col => $def) {
        try {
            $conn->exec("ALTER TABLE `users` ADD COLUMN `$col` $def;");
            echo "Added $col to users successfully.\n";
        } catch (\PDOException $e) {
            if ($e->getCode() == '42S21') {
                echo "Column $col already exists.\n";
            } else {
                echo "Notice for $col: " . $e->getMessage() . "\n";
            }
        }
    }

    // 2. Create user_interactions
    $conn->exec("
        CREATE TABLE IF NOT EXISTS `user_interactions` (
            `id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
            `user_id` BIGINT(20) UNSIGNED NOT NULL,
            `target_user_id` BIGINT(20) UNSIGNED NOT NULL,
            `type` ENUM('LIKE', 'PASS', 'MATCH', 'BLOCK', 'REPORT') NOT NULL,
            `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            UNIQUE KEY `unique_interaction` (`user_id`, `target_user_id`, `type`),
            FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
            FOREIGN KEY (`target_user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ");
    echo "Created user_interactions table.\n";

    // 3. Create user_daily_picks
    $conn->exec("
        CREATE TABLE IF NOT EXISTS `user_daily_picks` (
            `id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
            `user_id` BIGINT(20) UNSIGNED NOT NULL,
            `target_user_id` BIGINT(20) UNSIGNED NOT NULL,
            `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            UNIQUE KEY `unique_daily_pick` (`user_id`, `target_user_id`, `created_at`),
            FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
            FOREIGN KEY (`target_user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ");
    echo "Created user_daily_picks table.\n";

    // 4. Create user_views
    $conn->exec("
        CREATE TABLE IF NOT EXISTS `user_views` (
            `id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
            `user_id` BIGINT(20) UNSIGNED NOT NULL,
            `viewer_id` BIGINT(20) UNSIGNED NOT NULL,
            `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
            FOREIGN KEY (`viewer_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ");
    echo "Created user_views table.\n";

    // 5. Create explore_trending_categories
    $conn->exec("
        CREATE TABLE IF NOT EXISTS `explore_trending_categories` (
            `id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
            `name` VARCHAR(100) NOT NULL,
            `image_url` VARCHAR(255) DEFAULT NULL,
            `sort_order` INT(11) DEFAULT 0,
            PRIMARY KEY (`id`),
            UNIQUE KEY `unique_name` (`name`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ");
    echo "Created explore_trending_categories table.\n";

    // 6. Create explore_interests
    $conn->exec("
        CREATE TABLE IF NOT EXISTS `explore_interests` (
            `id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
            `name` VARCHAR(100) NOT NULL,
            `icon` VARCHAR(50) DEFAULT NULL,
            `sort_order` INT(11) DEFAULT 0,
            PRIMARY KEY (`id`),
            UNIQUE KEY `unique_name` (`name`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ");
    echo "Created explore_interests table.\n";

    // 7. Seed Trending Categories
    $trending = [
        'Coffee Date', 'Travel Buddy', 'Gym Partner', 'Movie Lovers',
        'Gamers', 'Food Lovers', 'Pet Lovers', 'Night Owls', 'Book Lovers'
    ];
    $stmt = $conn->prepare("INSERT IGNORE INTO `explore_trending_categories` (`name`, `sort_order`) VALUES (?, ?)");
    foreach ($trending as $i => $cat) {
        $stmt->execute([$cat, $i + 1]);
    }
    echo "Seeded explore_trending_categories.\n";

    // 8. Seed Explore Interests
    $interests = [
        'Music', 'Movies', 'Gaming', 'Travel', 'Fitness', 'Photography',
        'Reading', 'Anime', 'Food', 'Technology', 'Sports', 'Pets'
    ];
    $stmt = $conn->prepare("INSERT IGNORE INTO `explore_interests` (`name`, `sort_order`) VALUES (?, ?)");
    foreach ($interests as $i => $interest) {
        $stmt->execute([$interest, $i + 1]);
    }
    echo "Seeded explore_interests.\n";

    echo "Explore Migration completed successfully!\n";

} catch (\Exception $e) {
    echo "Migration Failed: " . $e->getMessage() . "\n";
}
