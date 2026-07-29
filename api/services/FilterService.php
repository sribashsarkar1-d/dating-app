<?php
namespace Api\Services;

class FilterService {

    /**
     * Build dynamic WHERE clause based on filters
     */
    public static function buildFilterQuery($filters, &$params) {
        $where = "";

        if (!empty($filters['age_min'])) {
            $where .= " AND u.age >= :age_min";
            $params['age_min'] = (int)$filters['age_min'];
        }
        
        if (!empty($filters['age_max'])) {
            $where .= " AND u.age <= :age_max";
            $params['age_max'] = (int)$filters['age_max'];
        }
        
        if (!empty($filters['height_min'])) {
            $where .= " AND up.height_cm >= :height_min";
            $params['height_min'] = (int)$filters['height_min'];
        }
        
        if (!empty($filters['height_max'])) {
            $where .= " AND up.height_cm <= :height_max";
            $params['height_max'] = (int)$filters['height_max'];
        }

        if (!empty($filters['education_id'])) {
            $where .= " AND up.education_id = :education_id";
            $params['education_id'] = (int)$filters['education_id'];
        }

        if (!empty($filters['profession'])) {
            $where .= " AND up.job_title LIKE :profession";
            $params['profession'] = '%' . $filters['profession'] . '%';
        }

        if (isset($filters['verified_only']) && $filters['verified_only'] == 1) {
            $where .= " AND up.is_verified = 1";
        }
        
        if (isset($filters['premium_only']) && $filters['premium_only'] == 1) {
            $where .= " AND u.is_premium = 1";
        }
        
        if (isset($filters['online_only']) && $filters['online_only'] == 1) {
            $where .= " AND u.last_seen >= (NOW() - INTERVAL 5 MINUTE)";
        }
        
        if (isset($filters['recently_active']) && $filters['recently_active'] == 1) {
            $where .= " AND u.last_seen >= (NOW() - INTERVAL 24 HOUR)";
        }

        return $where;
    }
}
