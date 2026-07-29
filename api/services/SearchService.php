<?php
namespace Api\Services;

class SearchService {

    /**
     * Get SQL where clause for searching
     */
    public static function getSearchWhereClause($query) {
        if (empty($query)) return "";
        
        // Prevent SQL injection by escaping properly in PDO, but here we build the query part
        return " AND (
            u.first_name LIKE :search 
            OR u.display_name LIKE :search 
            OR up.hometown LIKE :search 
            OR up.job_title LIKE :search 
            OR up.company LIKE :search 
            OR up.language_spoken LIKE :search
        )";
    }
}
