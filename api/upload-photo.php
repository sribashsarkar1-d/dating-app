<?php
require_once __DIR__ . '/helper/Response.php';

use Api\Helper\Response;

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    Response::error('Method not allowed', 405);
}

if (!isset($_FILES['photos']) || !is_array($_FILES['photos']['name'])) {
    // Fallback if they still use 'photo' instead of 'photos[]'
    if (isset($_FILES['photo']) && $_FILES['photo']['error'] === UPLOAD_ERR_OK) {
        $_FILES['photos'] = [
            'name' => [$_FILES['photo']['name']],
            'type' => [$_FILES['photo']['type']],
            'tmp_name' => [$_FILES['photo']['tmp_name']],
            'error' => [$_FILES['photo']['error']],
            'size' => [$_FILES['photo']['size']]
        ];
    } else {
        Response::error('No photos uploaded or upload error occurred.', 400);
    }
}

$uploadedFilenames = [];
$allowedTypes = ['image/jpeg', 'image/png', 'image/webp'];
$maxSize = 5 * 1024 * 1024; // 5MB
$targetDir = __DIR__ . '/uploads/temp/';

if (!is_dir($targetDir)) {
    mkdir($targetDir, 0755, true);
}

$fileCount = count($_FILES['photos']['name']);

for ($i = 0; $i < $fileCount; $i++) {
    if ($_FILES['photos']['error'][$i] !== UPLOAD_ERR_OK) {
        continue;
    }

    $type = $_FILES['photos']['type'][$i];
    $size = $_FILES['photos']['size'][$i];
    $name = $_FILES['photos']['name'][$i];
    $tmpName = $_FILES['photos']['tmp_name'][$i];

    if (!in_array($type, $allowedTypes)) {
        continue; // Skip invalid types
    }

    if ($size > $maxSize) {
        continue; // Skip large files
    }

    $ext = pathinfo($name, PATHINFO_EXTENSION);
    $filename = uniqid('temp_') . '_' . time() . '_' . $i . '.' . $ext;
    $targetFile = $targetDir . $filename;

    $moveResult = move_uploaded_file($tmpName, $targetFile);
    $lastError = error_get_last();
    
    // Save this for the debug output later!
    $_FILES['photos']['move_result'][$i] = $moveResult;
    $_FILES['photos']['move_error'][$i] = $lastError;

    if ($moveResult) {
        $uploadedFilenames[] = $filename;
    }
}

if (count($uploadedFilenames) > 0) {
    Response::success(count($uploadedFilenames) . ' photo(s) uploaded successfully.', [
        'filenames' => $uploadedFilenames
    ]);
} else {
    $debugInfo = [];
    for ($j = 0; $j < $fileCount; $j++) {
        $debugInfo[] = [
            'name' => $_FILES['photos']['name'][$j] ?? null,
            'tmp_name' => $_FILES['photos']['tmp_name'][$j] ?? null,
            'error' => $_FILES['photos']['error'][$j] ?? null,
            'type' => $_FILES['photos']['type'][$j] ?? null,
            'size' => $_FILES['photos']['size'][$j] ?? null,
            'allowed' => isset($_FILES['photos']['type'][$j]) ? in_array($_FILES['photos']['type'][$j], $allowedTypes) : false,
            'move_result' => $_FILES['photos']['move_result'][$j] ?? null,
            'move_error' => $_FILES['photos']['move_error'][$j] ?? null
        ];
    }
    Response::error('Failed to save uploaded photos or no valid photos provided.', 400, ['debug' => $debugInfo]);
}
