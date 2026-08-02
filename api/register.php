<?php
require_once __DIR__ . '/helper/Database.php';
require_once __DIR__ . '/helper/Response.php';
require_once __DIR__ . '/helper/Validator.php';
require_once __DIR__ . '/helper/Token.php';

use Api\Helper\Database;
use Api\Helper\Response;
use Api\Helper\Validator;
use Api\Helper\Token;

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    Response::error('Method not allowed', 405);
}

// Get Token
$headers = apache_request_headers();
$authHeader = $headers['Authorization'] ?? $headers['authorization'] ?? '';
$token = '';

if (preg_match('/Bearer\s(\S+)/', $authHeader, $matches)) {
    $token = $matches[1];
} else {
    $input = json_decode(file_get_contents('php://input'), true) ?? $_POST;
    $token = $input['registration_token'] ?? '';
}

if (!$token) {
    Response::error('Registration token is missing.', 401);
}

$input = json_decode(file_get_contents('php://input'), true) ?? $_POST;

try {
    $db = Database::getInstance();
    $conn = $db->getConnection();
    
    // Validate Token
    $hashedToken = Token::hashRegistrationToken($token);
    $tokenRecord = $db->fetch("SELECT * FROM registration_tokens WHERE token_hash = ? AND is_used = 0", [$hashedToken]);
    
    if (!$tokenRecord) {
        Response::error('Invalid or used registration token.', 401);
    }
    
    if (strtotime($tokenRecord['expires_at']) < time()) {
        Response::error('Registration token has expired.', 401);
    }
    
    $email = $tokenRecord['email'];
    
    // Validate inputs
    $firstName = Validator::sanitizeString($input['first_name'] ?? '');
    $lastName = Validator::sanitizeString($input['last_name'] ?? null);
    $dob = Validator::sanitizeString($input['birth_date'] ?? '');
    
    $errors = [];
    if (!$firstName) $errors['first_name'] = 'Required';
    if (!$dob) $errors['birth_date'] = 'Required';
    
    $showMe = Validator::sanitizeString($input['show_me'] ?? '');
    $showMeId = null;
    if (!$showMe) {
        $errors['show_me'] = 'Required';
    } else {
        $showMeRecord = $db->fetch("SELECT id FROM show_me WHERE name = ?", [$showMe]);
        if ($showMeRecord) {
            $showMeId = $showMeRecord['id'];
        } else {
            $errors['show_me'] = 'Invalid option';
        }
    }
    
    $height = $input['height'] ?? null;
    if ($height !== null && !is_numeric($height)) {
        $errors['height'] = 'Must be numeric';
    }
    
    $zodiacSign = Validator::sanitizeString($input['zodiac_sign'] ?? null);
    $hometown = Validator::sanitizeString($input['hometown'] ?? null);
    $languageSpoken = Validator::sanitizeString($input['language_spoken'] ?? null);
    $jobTitle = Validator::sanitizeString($input['job_title'] ?? null);
    $company = Validator::sanitizeString($input['company'] ?? null);

    $profilePrompts = $input['profile_prompts'] ?? [];
    if (!is_array($profilePrompts)) $errors['profile_prompts'] = 'Must be an array';
    
    $openingMoves = $input['opening_moves'] ?? [];
    if (!is_array($openingMoves)) $errors['opening_moves'] = 'Must be an array';
    
    $customOpeningMoves = $input['custom_opening_moves'] ?? [];
    if (!is_array($customOpeningMoves)) $errors['custom_opening_moves'] = 'Must be an array';
    
    $db = Database::getInstance();
    $conn = $db->getConnection();
    
    // Validate profile prompts
    if (is_array($profilePrompts)) {
        $promptIds = [];
        foreach ($profilePrompts as $index => $prompt) {
            $qId = $prompt['question_id'] ?? null;
            $ans = trim($prompt['answer'] ?? '');
            if (!$qId) {
                $errors["profile_prompts.{$index}.question_id"] = 'Required';
            } else {
                if (in_array($qId, $promptIds)) {
                    $errors["profile_prompts.{$index}.question_id"] = 'Duplicate question';
                } else {
                    $promptIds[] = $qId;
                    $isValid = $db->fetch("SELECT id FROM profile_prompts WHERE id = ? AND deleted_at IS NULL", [$qId]);
                    if (!$isValid) {
                        $errors["profile_prompts.{$index}.question_id"] = 'Invalid question.';
                    }
                }
            }
            if (!$ans) $errors["profile_prompts.{$index}.answer"] = 'Required';
        }
    }
    
    // Validate opening moves
    if (is_array($openingMoves)) {
        $moveIds = [];
        foreach ($openingMoves as $index => $move) {
            $qId = $move['question_id'] ?? null;
            $ans = trim($move['answer'] ?? '');
            if (!$qId) {
                $errors["opening_moves.{$index}.question_id"] = 'Required';
            } else {
                if (in_array($qId, $moveIds)) {
                    $errors["opening_moves.{$index}.question_id"] = 'Duplicate question';
                } else {
                    $moveIds[] = $qId;
                    $isValid = $db->fetch("SELECT id FROM opening_moves WHERE id = ? AND status = 'ACTIVE'", [$qId]);
                    if (!$isValid) {
                        $errors["opening_moves.{$index}.question_id"] = 'Invalid question.';
                    }
                }
            }
            if (!$ans) $errors["opening_moves.{$index}.answer"] = 'Required';
        }
    }
    
    // Validate custom opening moves
    if (is_array($customOpeningMoves)) {
        foreach ($customOpeningMoves as $index => $customMove) {
            $q = trim($customMove['question'] ?? '');
            $ans = trim($customMove['answer'] ?? '');
            if (!$q) $errors["custom_opening_moves.{$index}.question"] = 'Required';
            if (!$ans) $errors["custom_opening_moves.{$index}.answer"] = 'Required';
        }
    }

    if (!empty($errors)) {
        Response::error('Validation failed.', 400, ['errors' => $errors]);
    }
    
    $age = Validator::getAgeFromDob($dob);
    if ($age < 18) {
        Response::error('You must be at least 18 years old to register.', 400);
    }
    
    $genderId = $input['gender_identity_id'] ?? null;
    $interestedInId = $showMeId ?? ($input['interested_in_id'] ?? null);
    $relGoalId = $input['relationship_goal_id'] ?? null;
    $bio = Validator::sanitizeString($input['about'] ?? null);
    $educationId = $input['education_id'] ?? null;
    
    // Lifestyle options
    $smokingId = $input['smoking_id'] ?? null;
    $drinkingId = $input['drinking_id'] ?? null;
    $fitnessId = $input['fitness_id'] ?? null;
    $sleepId = $input['sleep_id'] ?? null;
    $dietId = $input['diet_id'] ?? null;
    
    $childrenId = $input['children_id'] ?? null;
    $connStyleId = $input['communication_style_id'] ?? null;
    $religionId = $input['religion_id'] ?? null;
    $politicalViewId = $input['political_view_id'] ?? null;
    
    $tempPhotoNames = $input['photo_filenames'] ?? [];
    if (!is_array($tempPhotoNames)) {
        $tempPhotoNames = [];
    }
    
    // Check if all provided photos exist in temp folder
    foreach ($tempPhotoNames as $photoName) {
        $photoName = Validator::sanitizeString($photoName);
        $tempPath = __DIR__ . '/uploads/temp/' . $photoName;
        if ($photoName && !file_exists($tempPath)) {
            Response::error("Uploaded photo '{$photoName}' not found.", 400);
        }
    }
    
    $conn->beginTransaction();
    
    try {
        // Insert User
        $userUuid = Token::generateUUID();
        $displayName = $firstName . ($lastName ? ' ' . substr($lastName, 0, 1) . '.' : '');
        
        $db->query(
            "INSERT INTO users (uuid, first_name, last_name, display_name, email, birth_date, gender_identity_id, interested_in_id, relationship_goal_id, status, onboarding_completed, created_at, updated_at) 
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'ACTIVE', 1, NOW(), NOW())",
            [$userUuid, $firstName, $lastName, $displayName, $email, $dob, $genderId, $interestedInId, $relGoalId]
        );
        
        $userId = $conn->lastInsertId();
        
        // Update Profile (Trigger already created the row)
        $db->query(
            "UPDATE user_profiles SET bio = ?, education_id = ?, religion_id = ?, political_view_id = ?, smoking_id = ?, drinking_id = ?, fitness_id = ?, sleep_id = ?, diet_id = ?, children_id = ?, communication_style_id = ?, is_verified = 0, zodiac_sign = ?, height_cm = ?, hometown = ?, language_spoken = ?, job_title = ?, company = ?, updated_at = NOW() 
             WHERE user_id = ?",
            [$bio, $educationId, $religionId, $politicalViewId, $smokingId, $drinkingId, $fitnessId, $sleepId, $dietId, $childrenId, $connStyleId, $zodiacSign, $height, $hometown, $languageSpoken, $jobTitle, $company, $userId]
        );
        
        // Save Profile Prompts
        if (!empty($profilePrompts)) {
            $promptStmt = $conn->prepare("INSERT INTO user_profile_prompts (user_id, question_id, answer, created_at) VALUES (?, ?, ?, NOW())");
            foreach ($profilePrompts as $prompt) {
                $promptStmt->execute([$userId, $prompt['question_id'], trim($prompt['answer'])]);
            }
        }
        
        // Save Opening Moves
        if (!empty($openingMoves)) {
            $moveStmt = $conn->prepare("INSERT INTO user_opening_moves (user_id, question_id, answer, created_at) VALUES (?, ?, ?, NOW())");
            foreach ($openingMoves as $move) {
                $moveStmt->execute([$userId, $move['question_id'], trim($move['answer'])]);
            }
        }
        
        // Save Custom Opening Moves
        if (!empty($customOpeningMoves)) {
            $customMoveStmt = $conn->prepare("INSERT INTO user_opening_moves (user_id, custom_question, answer, created_at) VALUES (?, ?, ?, NOW())");
            foreach ($customOpeningMoves as $customMove) {
                $customMoveStmt->execute([$userId, trim($customMove['question']), trim($customMove['answer'])]);
            }
        }
        
        // Process Photos
        if (!empty($tempPhotoNames)) {
            $userPhotoDir = __DIR__ . '/uploads/users/' . $userId . '/';
            if (!is_dir($userPhotoDir)) {
                mkdir($userPhotoDir, 0755, true);
            }
            
            $displayOrder = 0;
            foreach ($tempPhotoNames as $photoName) {
                $photoName = Validator::sanitizeString($photoName);
                if (!$photoName) continue;
                
                $tempPath = __DIR__ . '/uploads/temp/' . $photoName;
                $newPhotoPath = $userPhotoDir . $photoName;
                
                if (file_exists($tempPath)) {
                    if (!copy($tempPath, $newPhotoPath)) {
                        throw new \Exception("Failed to move photo '{$photoName}'.");
                    }
                    
                    $photoUrl = 'api/uploads/users/' . $userId . '/' . $photoName;
                    $photoUuid = Token::generateUUID();
                    
                    // First photo is main
                    $isMain = ($displayOrder === 0) ? 1 : 0;
                    
                    $db->query(
                        "INSERT INTO user_photos (uuid, user_id, photo_url, is_main, display_order, created_at, updated_at) 
                         VALUES (?, ?, ?, ?, ?, NOW(), NOW())",
                        [$photoUuid, $userId, $photoUrl, $isMain, $displayOrder]
                    );
                    
                    $displayOrder++;
                }
            }
        }
        
        // Mark token as used
        $db->query("UPDATE registration_tokens SET is_used = 1, updated_at = NOW() WHERE id = ?", [$tokenRecord['id']]);
        
        $conn->commit();
        
        // Cleanup temp photos
        foreach ($tempPhotoNames as $photoName) {
            $photoName = Validator::sanitizeString($photoName);
            $tempPath = __DIR__ . '/uploads/temp/' . $photoName;
            if ($photoName && file_exists($tempPath)) {
                unlink($tempPath);
            }
        }
        
        $authToken = Token::generateAuthToken($userId);
        
        Response::success('Registration completed successfully.', [
            'user_id' => $userId,
            'email' => $email,
            'auth_token' => $authToken
        ], 201);
        
    } catch (\Exception $e) {
        $conn->rollBack();
        
        // Delete temp photos if an error occurred to ensure rollback includes files
        foreach ($tempPhotoNames as $photoName) {
            $photoName = Validator::sanitizeString($photoName);
            $tempPath = __DIR__ . '/uploads/temp/' . $photoName;
            if ($photoName && file_exists($tempPath)) {
                unlink($tempPath);
            }
        }
        
        throw $e; // Re-throw to catch block outside
    }
    
} catch (\Exception $e) {
    Response::error('Registration failed: ' . $e->getMessage(), 500);
}
