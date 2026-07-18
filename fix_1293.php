<?php
$file = 'dating-app (3).sql';

if (file_exists($file)) {
    $content = file_get_contents($file);
    
    // Fix #1293 Error for MySQL 5.5 compatibility
    // We change `updated_at` to just 'timestamp NULL DEFAULT NULL' 
    // because MySQL 5.5 only allows one column to use CURRENT_TIMESTAMP
    $content = preg_replace(
        '/`updated_at`\s+timestamp\s+NOT\s+NULL\s+DEFAULT\s+current_timestamp\(\)(?:\s+ON\s+UPDATE\s+current_timestamp\(\))?/i', 
        '`updated_at` timestamp NULL DEFAULT NULL', 
        $content
    );
    
    file_put_contents($file, $content);
    echo "Fixed #1293 for $file.\n";
} else {
    echo "File not found.";
}
