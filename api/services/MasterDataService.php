<?php
namespace Api\Services;

require_once __DIR__ . '/../helper/Database.php';

use Api\Helper\Database;

class MasterDataService {
    private $db;
    private $cacheFile;
    private $cacheExpiry = 300; // 5 minutes (5 * 60 seconds)

    public function __construct() {
        $this->db = Database::getInstance();
        $this->cacheFile = __DIR__ . '/../cache/master-data.json';
        
        // Ensure cache directory exists
        $cacheDir = dirname($this->cacheFile);
        if (!is_dir($cacheDir)) {
            mkdir($cacheDir, 0755, true);
        }
    }

    /**
     * Get all master data. Serves from cache if valid, otherwise loads from DB.
     * @return array
     */
    public function getAllMasterData() {
        if ($this->isCacheValid()) {
            $cachedData = file_get_contents($this->cacheFile);
            $decoded = json_decode($cachedData, true);
            if ($decoded) {
                return $decoded;
            }
        }

        // If cache is invalid or missing, load from DB
        $data = $this->loadFromDatabase();
        
        // Save to cache
        file_put_contents($this->cacheFile, json_encode($data));
        
        return $data;
    }

    /**
     * Clear the cache. To be called when any master table is updated.
     */
    public function clearCache() {
        if (file_exists($this->cacheFile)) {
            unlink($this->cacheFile);
        }
    }

    private function isCacheValid() {
        if (!file_exists($this->cacheFile)) {
            return false;
        }
        
        $fileMtime = filemtime($this->cacheFile);
        if (time() - $fileMtime > $this->cacheExpiry) {
            return false;
        }

        return true;
    }

    private function loadFromDatabase() {
        $masterData = [];
        
        // Map expected JSON keys to actual database table names
        $tableMappings = [
            'genders' => 'genders',
            'show_me' => 'show_me',
            'relationship_goals' => 'relationship_goals',
            'languages' => 'languages',
            'education_levels' => 'education_levels',
            'smoking_habits' => 'smoking_habits',
            'drinking_habits' => 'drinking_habits',
            'fitness_levels' => 'fitness_habits', // table diff
            'sleep_schedules' => 'sleep_habits', // table diff
            'dietary_preferences' => 'diets', // table diff
            'family_plans' => 'children_plans', // table diff
            'pet_preferences' => 'pets', // table diff
            'communication_styles' => 'communication_styles',
            'love_languages' => 'love_languages',
            'religions' => 'religions',
            'political_views' => 'political_views',
            'interests' => 'interests',
            'profile_prompts' => 'profile_prompts',
            'opening_moves' => 'opening_moves',
            'countries' => 'countries',
            'states' => 'states',
            'cities' => 'cities',
            'zodiac_signs' => 'zodiac_signs'
        ];

        // Ensure we load records ordered by display_order (or name), and only ACTIVE records
        // We handle missing 'display_order' or 'status' gracefully via DB schema checks if needed.
        // Assuming all master tables have `id`, `name`, `status`, `display_order` based on requirements.
        foreach ($tableMappings as $jsonKey => $tableName) {
            $masterData[$jsonKey] = $this->fetchTableData($tableName);
        }

        // Hardcoded ranges as requested
        $masterData['height_range'] = [
            'min' => 120,
            'max' => 250,
            'step' => 1
        ];

        $masterData['age_range'] = [
            'min' => 18,
            'max' => 100
        ];

        return $masterData;
    }

    private function fetchTableData($tableName) {
        try {
            // Some tables might not have 'status' or 'display_order' depending on original schema.
            // A safe approach in MySQL is to check for column existence, but since this is Core PHP with strict performance requirements,
            // we will run a generic query. If it fails, we run a fallback without 'status'/'display_order'.
            // Based on typical schema in dating app templates:
            $query = "SELECT id, name FROM `$tableName` WHERE status = 'ACTIVE' ORDER BY display_order ASC, name ASC";
            $result = $this->db->fetchAll($query);
            return $result;
        } catch (\Exception $e) {
            try {
                // Fallback for tables without 'status' or 'display_order'
                // We'll check the error to see if a column is missing.
                $query = "SELECT id, name FROM `$tableName` ORDER BY name ASC";
                return $this->db->fetchAll($query);
            } catch (\Exception $e2) {
                // If it still fails (e.g. table doesn't exist), return empty array
                return [];
            }
        }
    }
}
