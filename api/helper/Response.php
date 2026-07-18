<?php
namespace Api\Helper;

class Response {
    public static function json($status, $message, $data = [], $statusCode = 200) {
        http_response_code($statusCode);
        header('Content-Type: application/json; charset=utf-8');
        
        $response = [
            'status' => $status,
            'message' => $message
        ];
        
        if (!empty($data)) {
            $response['data'] = $data;
        }
        
        echo json_encode($response);
        exit;
    }

    public static function success($message, $data = [], $statusCode = 200) {
        self::json('success', $message, $data, $statusCode);
    }

    public static function error($message, $statusCode = 400, $data = []) {
        self::json('error', $message, $data, $statusCode);
    }
}
