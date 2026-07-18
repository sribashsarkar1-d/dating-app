<?php
$file = 'dating-app (3).sql';

if (file_exists($file)) {
    $content = file_get_contents($file);
    
    // Replace the generated column definition to be a regular column with DEFAULT NULL
    // This is because older MySQL versions (5.5, 5.6) don't support GENERATED ALWAYS AS ... VIRTUAL
    $content = preg_replace(
        '/GENERATED\s+ALWAYS\s+AS\s+\(timestampdiff\(YEAR,`birth_date`,curdate\(\)\)\)\s+VIRTUAL/i',
        'DEFAULT NULL',
        $content
    );
    
    file_put_contents($file, $content);
    echo "Fixed #1064 error (Virtual Column removed) for $file.\n";
} else {
    echo "File not found.";
}
