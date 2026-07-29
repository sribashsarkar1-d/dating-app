<?php
namespace Api\Services;

class DistanceService {

    /**
     * Get the SQL snippet for Haversine distance calculation in Kilometers
     */
    public static function getHaversineSQL($latColumn, $lngColumn, $userLat, $userLng) {
        $userLat = (float) $userLat;
        $userLng = (float) $userLng;
        
        return "(6371 * acos(
                    cos(radians({$userLat})) * cos(radians({$latColumn})) *
                    cos(radians({$lngColumn}) - radians({$userLng})) +
                    sin(radians({$userLat})) * sin(radians({$latColumn}))
                ))";
    }

    /**
     * Calculate distance in PHP (if needed)
     */
    public static function calculateDistance($lat1, $lon1, $lat2, $lon2) {
        $earthRadius = 6371; // km
        
        $lat1 = deg2rad((float)$lat1);
        $lon1 = deg2rad((float)$lon1);
        $lat2 = deg2rad((float)$lat2);
        $lon2 = deg2rad((float)$lon2);
        
        $latDelta = $lat2 - $lat1;
        $lonDelta = $lon2 - $lon1;
        
        $a = sin($latDelta / 2) * sin($latDelta / 2) +
             cos($lat1) * cos($lat2) *
             sin($lonDelta / 2) * sin($lonDelta / 2);
             
        $c = 2 * atan2(sqrt($a), sqrt(1 - $a));
        return round($earthRadius * $c, 2);
    }
}
