<?php
$file = 'dating-app (3).sql';

if (file_exists($file)) {
    $content = file_get_contents($file);
    
    $lines = explode("\n", $content);
    $changed = 0;
    
    foreach ($lines as &$line) {
        // If this line has 'timestamp' and 'current_timestamp()'
        if (stripos($line, 'timestamp') !== false && stripos($line, 'current_timestamp') !== false) {
            // Check if it's NOT the `created_at` column
            if (stripos($line, '`created_at`') === false) {
                // Completely replace the data type definition with 'timestamp NULL DEFAULT NULL'
                // This handles `NOT NULL`, `NULL`, `ON UPDATE...` everything correctly.
                $line = preg_replace(
                    '/timestamp.*current_timestamp\(\)(?:\s+ON\s+UPDATE\s+current_timestamp\(\))?/i',
                    'timestamp NULL DEFAULT NULL',
                    $line
                );
                // In case there is a trailing comma that might get swallowed if regex was greedy,
                // but the above regex only replaces up to current_timestamp() optionally with ON UPDATE.
                // Let's just be very safe:
                // Actually, the above regex is fine since `.*` might be greedy.
                // Let's use `.*?` to be non-greedy.
                // Better yet: just replace the exact timestamp definition chunk.
            }
        }
    }
    
    // Actually a simpler robust regex for the whole content:
    // We want to replace any timestamp definition that has current_timestamp() in it, except on `created_at` line.
    
    $lines2 = explode("\n", file_get_contents($file));
    foreach ($lines2 as &$line2) {
        if (stripos($line2, 'timestamp') !== false && stripos($line2, 'current_timestamp') !== false) {
            if (stripos($line2, '`created_at`') === false) {
                // Find where "timestamp" starts
                $pos = stripos($line2, 'timestamp');
                // The part before "timestamp" (like `  `updated_at` `)
                $prefix = substr($line2, 0, $pos);
                // Check if it has a comma at the end
                $suffix = (substr(trim($line2), -1) === ',') ? ',' : '';
                
                $line2 = $prefix . "timestamp NULL DEFAULT NULL" . $suffix;
                $changed++;
            }
        }
    }
    
    file_put_contents($file, implode("\n", $lines2));
    echo "Fixed $changed columns with robust #1293 fix in $file.\n";
} else {
    echo "File not found.";
}
