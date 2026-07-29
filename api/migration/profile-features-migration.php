<?php
require_once __DIR__ . '/../helper/Database.php';
use Api\Helper\Database;

try {
    $db = Database::getInstance();
    $conn = $db->getConnection();
    
    echo "Starting migration...\n";

    // 1. Alter user_profiles table
    $columns = [
        "zodiac_sign" => "VARCHAR(50) DEFAULT NULL",
        "show_me" => "VARCHAR(50) DEFAULT NULL",
        "language_spoken" => "VARCHAR(255) DEFAULT NULL",
        "job_title" => "VARCHAR(191) DEFAULT NULL"
    ];

    foreach ($columns as $col => $def) {
        try {
            $conn->exec("ALTER TABLE `user_profiles` ADD COLUMN `$col` $def;");
            echo "Added $col to user_profiles successfully.\n";
        } catch (\PDOException $e) {
            if ($e->getCode() == '42S21') { // Column already exists
                echo "Column $col already exists.\n";
            } else {
                echo "Notice for $col: " . $e->getMessage() . "\n";
            }
        }
    }

    // 2. Create profile_prompt_questions
    $conn->exec("
        CREATE TABLE IF NOT EXISTS `profile_prompt_questions` (
            `id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
            `question` VARCHAR(255) NOT NULL,
            `status` ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
            `sort_order` INT(11) DEFAULT 0,
            `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            `updated_at` DATETIME NULL DEFAULT NULL,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ");
    echo "Created profile_prompt_questions table.\n";

    // 3. Create user_profile_prompts
    $conn->exec("
        CREATE TABLE IF NOT EXISTS `user_profile_prompts` (
            `id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
            `user_id` BIGINT(20) UNSIGNED NOT NULL,
            `question_id` BIGINT(20) UNSIGNED NOT NULL,
            `answer` TEXT NOT NULL,
            `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            `updated_at` DATETIME NULL DEFAULT NULL,
            PRIMARY KEY (`id`),
            FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
            FOREIGN KEY (`question_id`) REFERENCES `profile_prompt_questions`(`id`) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ");
    echo "Created user_profile_prompts table.\n";

    // 4. Create opening_move_questions
    $conn->exec("
        CREATE TABLE IF NOT EXISTS `opening_move_questions` (
            `id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
            `question` VARCHAR(255) NOT NULL,
            `status` ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
            `sort_order` INT(11) DEFAULT 0,
            `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            `updated_at` DATETIME NULL DEFAULT NULL,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ");
    echo "Created opening_move_questions table.\n";

    // 5. Create user_opening_moves
    $conn->exec("
        CREATE TABLE IF NOT EXISTS `user_opening_moves` (
            `id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
            `user_id` BIGINT(20) UNSIGNED NOT NULL,
            `question_id` BIGINT(20) UNSIGNED DEFAULT NULL,
            `custom_question` VARCHAR(255) DEFAULT NULL,
            `answer` TEXT NOT NULL,
            `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            `updated_at` DATETIME NULL DEFAULT NULL,
            PRIMARY KEY (`id`),
            FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
            FOREIGN KEY (`question_id`) REFERENCES `opening_move_questions`(`id`) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ");
    echo "Created user_opening_moves table.\n";

    // 6. Seed Data (Profile Prompts)
    $prompts = [
        ['My biggest strength is...', 1],
        ['Dating me is like...', 2],
        ['Together we could...', 3],
        ['I geek out on...', 4],
        ['The best way to ask me out is...', 5]
    ];
    $stmt = $conn->prepare("INSERT INTO `profile_prompt_questions` (`question`, `sort_order`) SELECT ?, ? FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `profile_prompt_questions` WHERE `question` = ?)");
    foreach ($prompts as $p) {
        $stmt->execute([$p[0], $p[1], $p[0]]);
    }
    echo "Seeded profile_prompt_questions.\n";

    // 7. Seed Data (Opening Moves)
    $moves = [
        ["What's your ideal first date?", 1],
        ["Coffee or Tea?", 2],
        ["Beach or Mountains?", 3],
        ["What's the last show you binge-watched?", 4],
        ["If you could travel anywhere tomorrow, where would it be?", 5]
    ];
    $stmt = $conn->prepare("INSERT INTO `opening_move_questions` (`question`, `sort_order`) SELECT ?, ? FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `opening_move_questions` WHERE `question` = ?)");
    foreach ($moves as $m) {
        $stmt->execute([$m[0], $m[1], $m[0]]);
    }
    echo "Seeded opening_move_questions.\n";

    echo "Migration completed successfully!\n";

} catch (\Exception $e) {
    echo "Migration Failed: " . $e->getMessage() . "\n";
}
