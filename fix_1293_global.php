<?php
$file = 'dating-app (3).sql';

if (file_exists($file)) {
    $content = file_get_contents($file);
    
    // Find all lines containing 'timestamp NOT NULL DEFAULT current_timestamp()'
    // and if the column is NOT 'created_at', change it to 'timestamp NULL DEFAULT NULL'.
    
    $lines = explode("\n", $content);
    foreach ($lines as &$line) {
        if (stripos($line, 'timestamp NOT NULL DEFAULT current_timestamp') !== false) {
            // Check if it's NOT created_at
            if (stripos($line, '`created_at`') === false) {
                // It's some other column like expires_at, updated_at, etc.
                // Replace the whole 'timestamp NOT NULL DEFAULT current_timestamp()...' part
                $line = preg_replace(
                    '/timestamp\s+NOT\s+NULL\s+DEFAULT\s+current_timestamp\(\)(?:\s+ON\s+UPDATE\s+current_timestamp\(\))?/i',
                    'timestamp NULL DEFAULT NULL',
                    $line
                );
            }
        }
    }
    
    file_put_contents($file, implode("\n", $lines));
    echo "Fixed all #1293 errors for all columns in $file.\n";
} else {
    echo "File not found.";
}
