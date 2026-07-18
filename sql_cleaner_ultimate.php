<?php
$file = 'dating-app (3).sql';

if (file_exists($file)) {
    $content = file_get_contents($file);

    // 1. Remove DEFINER (matches both views, procedures, and triggers)
    $content = preg_replace('/\\s*DEFINER\\s*=\\s*`[^`]+`@`[^`]+`\\s*/i', ' ', $content);

    // 2. Remove DEFAULT uuid() for MySQL 5.7 compatibility
    $content = preg_replace('/DEFAULT\\s+uuid\\(\\)/i', '', $content);

    // 3. Remove all PROCEDURES (if any exist between DELIMITER $$ and DELIMITER ;)
    // We match CREATE PROCEDURE and remove everything until the next DELIMITER ;
    $content = preg_replace('/DELIMITER\s+\$\$\s*CREATE\s+PROCEDURE.*?DELIMITER\s+;/is', '', $content);
    
    // Fallback for Procedures without DELIMITER
    $content = preg_replace('/CREATE\s+PROCEDURE.*?(?:END\$\$|END;)/is', '', $content);

    // 4. Remove all TRIGGERS
    $content = preg_replace('/DELIMITER\s+\$\$\s*CREATE\s+TRIGGER.*?DELIMITER\s+;/is', '', $content);
    
    // Fallback for Triggers without DELIMITER
    $content = preg_replace('/CREATE\s+TRIGGER.*?(?:END\$\$|END;)/is', '', $content);
    
    // Clean up standalone DELIMITER $$ or DELIMITER ; if they are left over
    $content = preg_replace('/DELIMITER\s+\$\$/i', '', $content);
    $content = preg_replace('/DELIMITER\s+;/i', '', $content);

    file_put_contents($file, $content);
    echo "ULTIMATE CLEAN: Removed DEFINER, DEFAULT uuid(), PROCEDURES, and TRIGGERS.\n";
} else {
    echo "File not found: $file\n";
}
