<?php
namespace Api\Services;

class SearchService {

    /**
     * Get SQL where clause for searching
     */
    public static function getSearchWhereClause($query, &$params) {
        if (empty($query)) return "";
        
        $term = '%' . $query . '%';
        $params['search1'] = $term;
        $params['search2'] = $term;
        $params['search3'] = $term;
        $params['search4'] = $term;
        $params['search5'] = $term;
        $params['search6'] = $term;

        return " AND (
            first_name LIKE :search1 
            OR display_name LIKE :search2 
            OR hometown LIKE :search3 
            OR job_title LIKE :search4 
            OR company LIKE :search5 
            OR language_spoken LIKE :search6
        )";
    }
}
