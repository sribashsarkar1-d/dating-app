<?php
require_once __DIR__ . '/helper/Database.php';
require_once __DIR__ . '/helper/Response.php';
require_once __DIR__ . '/helper/Auth.php';

use Api\Helper\Database;
use Api\Helper\Response;
use Api\Helper\Auth;

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    Response::error('Method not allowed', 405);
}

try {
    // Middleware: Verifies token and returns user_id
    $currentUserId = Auth::authenticate();

    $db = Database::getInstance();
    
    // Pagination parameters
    $page = isset($_GET['page']) ? max(1, intval($_GET['page'])) : 1;
    $limit = isset($_GET['limit']) ? max(1, intval($_GET['limit'])) : 20;
    if ($limit > 50) $limit = 50; // Max limit
    
    $offset = ($page - 1) * $limit;

    // Fetch all active users EXCEPT the current user
    // Only fetch public info (no email, no phone, no precise location coordinates)
    $usersQuery = "
        SELECT 
            u.id, u.uuid, u.display_name, u.age, u.onboarding_completed,
            g.name as gender_identity,
            p.bio, p.hometown, p.compatibility_score_base, p.is_verified,
            (SELECT photo_url FROM user_photos up WHERE up.user_id = u.id AND up.is_main = 1 LIMIT 1) as main_photo_url
        FROM users u
        LEFT JOIN user_profiles p ON u.id = p.user_id
        LEFT JOIN genders g ON u.gender_identity_id = g.id
        WHERE u.id != ? AND u.status = 'ACTIVE'
        ORDER BY u.created_at DESC
        LIMIT ? OFFSET ?
    ";
    
    // Since PDO emulate prepares is false, we must bind limit and offset as integers explicitly
    // In our custom DB helper, we are using execute([$params]) which treats everything as strings.
    // So we need to bind properly or use a direct PDO call if the helper fails, but let's test our helper first.
    // Actually, PDO with ATTR_EMULATE_PREPARES=false requires LIMIT variables to be integers.
    // Let's bypass the helper for this specific query to ensure PDO::PARAM_INT is used.
    
    $conn = $db->getConnection();
    $stmt = $conn->prepare($usersQuery);
    $stmt->bindValue(1, $currentUserId, \PDO::PARAM_INT);
    $stmt->bindValue(2, $limit, \PDO::PARAM_INT);
    $stmt->bindValue(3, $offset, \PDO::PARAM_INT);
    $stmt->execute();
    
    $users = $stmt->fetchAll(\PDO::FETCH_ASSOC);

    // Get total count for pagination metadata
    $countQuery = "SELECT COUNT(*) as total FROM users WHERE id != ? AND status = 'ACTIVE'";
    $totalResult = $db->fetch($countQuery, [$currentUserId]);
    $totalUsers = $totalResult['total'];
    $totalPages = ceil($totalUsers / $limit);

    Response::success('Users fetched successfully.', [
        'users' => $users,
        'pagination' => [
            'current_page' => $page,
            'per_page' => $limit,
            'total_users' => $totalUsers,
            'total_pages' => $totalPages,
            'has_more' => $page < $totalPages
        ]
    ]);

} catch (\Exception $e) {
    Response::error('Internal Server Error: ' . $e->getMessage(), 500);
}
