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
            first_name LIKE :search 
            OR display_name LIKE :search 
            OR hometown LIKE :search 
            OR job_title LIKE :search 
            OR company LIKE :search 
            OR language_spoken LIKE :search
        )";
    }
}
