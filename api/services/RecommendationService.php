<?php
namespace Api\Services;

class RecommendationService {

    /**
     * Calculate Compatibility Score and Reason between two users
     */
    public static function generateCompatibility($currentUser, $targetUser, $mutualInterests = 0) {
        $score = 50; // Base score
        $reasons = [];

        // 1. Same Relationship Goal
        if (isset($currentUser['relationship_goal_id']) && isset($targetUser['relationship_goal_id']) 
            && $currentUser['relationship_goal_id'] == $targetUser['relationship_goal_id']) {
            $score += 15;
            $reasons[] = "You share the same relationship goals";
        }

        // 2. Mutual Interests
        if ($mutualInterests > 0) {
            $score += ($mutualInterests * 5);
            $reasons[] = "You have $mutualInterests mutual interests";
        }

        // 3. Distance Score
        if (isset($targetUser['distance'])) {
            $dist = (float)$targetUser['distance'];
            if ($dist < 10) {
                $score += 15;
                $reasons[] = "They are very close to you";
            } else if ($dist < 25) {
                $score += 10;
            }
        }

        // 4. Same Education Level
        if (isset($currentUser['education_id']) && isset($targetUser['education_id']) 
            && $currentUser['education_id'] == $targetUser['education_id']) {
            $score += 5;
        }

        // 5. Same Profession/Job Title
        if (!empty($currentUser['job_title']) && !empty($targetUser['job_title']) 
            && strtolower(trim($currentUser['job_title'])) === strtolower(trim($targetUser['job_title']))) {
            $score += 10;
            $reasons[] = "You both work as {$currentUser['job_title']}";
        }

        // 6. Premium / Verified
        if (!empty($targetUser['is_verified'])) {
            $score += 5;
        }
        if (!empty($targetUser['is_premium'])) {
            $score += 2;
        }

        // 7. Active Recently
        if (!empty($targetUser['last_seen'])) {
            $lastSeen = strtotime($targetUser['last_seen']);
            if ((time() - $lastSeen) < (24 * 3600)) {
                $score += 5; // Active in last 24h
            }
        }

        // Cap score at 99 (or 100)
        $score = min($score, 99);

        // Build reason text
        $reasonText = "";
        if (!empty($reasons)) {
            $reasonText = "Because " . strtolower(implode(" and ", array_slice($reasons, 0, 2))) . ".";
        } else {
            $reasonText = "Because you have a solid matching profile.";
        }

        return [
            'score' => $score . '%',
            'reason' => ucfirst($reasonText)
        ];
    }
}
