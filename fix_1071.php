<?php
$file = 'dating-app (3).sql';

if (file_exists($file)) {
    $content = file_get_contents($file);
    
    // Change varchar(255) to varchar(191) to avoid #1071 error on utf8mb4 in older MySQL
    $content = str_ireplace('varchar(255)', 'varchar(191)', $content);
    
    // Also, if there are any varchar(256+) that are indexed, we might need to handle them,
    // but typically it's just email or token columns that are 255.
    
    file_put_contents($file, $content);
    echo "Fixed #1071 error by changing varchar(255) to varchar(191).\n";
} else {
    echo "File not found.";
}
