<?php
$file = 'dating-app (3).sql';

if (file_exists($file)) {
    $content = file_get_contents($file);
    
    // 1. Remove DEFINER entirely (from views or anything else)
    $content = preg_replace('/\\s*DEFINER\\s*=\\s*`[^`]+`@`[^`]+`\\s*/i', ' ', $content);
    
    // 2. Remove DEFAULT uuid() for MySQL 5.7 compatibility
    $content = preg_replace('/DEFAULT\\s+uuid\\(\\)/i', '', $content);
    
    // 3. (Optional but just in case) Remove any DELIMITER blocks if they sneaked in
    $content = preg_replace('/DELIMITER\s+\$\$.*?DELIMITER\s+;/is', '', $content);
    
    file_put_contents($file, $content);
    echo "Done! Cleaned $file.\n";
} else {
    echo "File not found.";
}
