<?php
namespace Api\Services;

class ExploreService {

    /**
     * Get the base SQL query to fetch users for explore, excluding matched, passed, blocked, etc.
     */
    public static function getBaseExploreQuery($currentUserId) {
        // Exclude interactions (LIKE, PASS, MATCH, BLOCK, REPORT)
        $excludeInteractions = "SELECT target_user_id FROM user_interactions WHERE user_id = {$currentUserId}";
        
        // Also exclude if the other person blocked/reported this user
        $excludeBlockedBy = "SELECT user_id FROM user_interactions WHERE target_user_id = {$currentUserId} AND type IN ('BLOCK', 'REPORT')";
        
        return "
            SELECT 
                u.id, u.first_name, u.birth_date, u.age, u.is_premium, u.last_seen,
                up.bio, up.height_cm, up.hometown, up.job_title, up.company, up.is_verified, up.base_latitude, up.base_longitude, up.zodiac_sign, up.language_spoken
            FROM users u
            JOIN user_profiles up ON u.id = up.user_id
            WHERE u.id != {$currentUserId}
            AND u.status = 'ACTIVE'
            AND u.id NOT IN ($excludeInteractions)
            AND u.id NOT IN ($excludeBlockedBy)
        ";
    }

    /**
     * Format a user record for the Explore API response
     */
    public static function formatUserResponse($user, $db) {
        // Fetch main photo
        $photo = $db->fetch("SELECT photo_url FROM user_photos WHERE user_id = ? ORDER BY is_main DESC, display_order ASC LIMIT 1", [$user['id']]);
        
        return [
            'id' => (int)$user['id'],
            'first_name' => $user['first_name'],
            'age' => (int)$user['age'],
            'is_verified' => (bool)($user['is_verified'] ?? 0),
            'is_premium' => (bool)($user['is_premium'] ?? 0),
            'job_title' => $user['job_title'],
            'company' => $user['company'],
            'distance_km' => isset($user['distance']) ? round($user['distance'], 1) : null,
            'photo' => $photo ? $photo['photo_url'] : null,
            'compatibility' => isset($user['compatibility']) ? $user['compatibility'] : null,
            'compatibility_reason' => isset($user['compatibility_reason']) ? $user['compatibility_reason'] : null,
        ];
    }
}
