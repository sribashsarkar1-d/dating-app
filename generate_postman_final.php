<?php

$baseUrl = '{{base_url}}';

$collection = [
    'info' => [
        'name' => 'Dating App API - Final',
        'schema' => 'https://schema.getpostman.com/json/collection/v2.1.0/collection.json'
    ],
    'item' => [
        // FOLDER: Registration
        [
            'name' => '1. Registration',
            'item' => [
                [
                    'name' => '1. Send OTP',
                    'request' => [
                        'method' => 'POST',
                        'header' => [],
                        'body' => [
                            'mode' => 'raw',
                            'raw' => "{\n    \"email\": \"{{email}}\"\n}",
                            'options' => ['raw' => ['language' => 'json']]
                        ],
                        'url' => ['raw' => "$baseUrl/send-otp.php", 'host' => ["$baseUrl"], 'path' => ['send-otp.php']]
                    ]
                ],
                [
                    'name' => '2. Resend OTP',
                    'request' => [
                        'method' => 'POST',
                        'header' => [],
                        'body' => [
                            'mode' => 'raw',
                            'raw' => "{\n    \"email\": \"{{email}}\"\n}",
                            'options' => ['raw' => ['language' => 'json']]
                        ],
                        'url' => ['raw' => "$baseUrl/resend-otp.php", 'host' => ["$baseUrl"], 'path' => ['resend-otp.php']]
                    ]
                ],
                [
                    'name' => '3. Verify OTP',
                    'event' => [
                        [
                            'listen' => 'test',
                            'script' => [
                                'exec' => [
                                    'var jsonData = pm.response.json();',
                                    'if (jsonData.data && jsonData.data.registration_token) {',
                                    '    pm.collectionVariables.set("registration_token", jsonData.data.registration_token);',
                                    '}'
                                ],
                                'type' => 'text/javascript'
                            ]
                        ]
                    ],
                    'request' => [
                        'method' => 'POST',
                        'header' => [],
                        'body' => [
                            'mode' => 'raw',
                            'raw' => "{\n    \"email\": \"{{email}}\",\n    \"otp\": \"123456\"\n}",
                            'options' => ['raw' => ['language' => 'json']]
                        ],
                        'url' => ['raw' => "$baseUrl/verify-otp.php", 'host' => ["$baseUrl"], 'path' => ['verify-otp.php']]
                    ]
                ],
                [
                    'name' => '4. Upload Photo',
                    'event' => [
                        [
                            'listen' => 'test',
                            'script' => [
                                'exec' => [
                                    'var jsonData = pm.response.json();',
                                    'if (jsonData.data && jsonData.data.filenames) {',
                                    '    pm.collectionVariables.set("photo_filenames", JSON.stringify(jsonData.data.filenames));',
                                    '}'
                                ],
                                'type' => 'text/javascript'
                            ]
                        ]
                    ],
                    'request' => [
                        'method' => 'POST',
                        'header' => [],
                        'body' => [
                            'mode' => 'formdata',
                            'formdata' => [
                                ['key' => 'photos[]', 'type' => 'file', 'src' => []]
                            ]
                        ],
                        'url' => ['raw' => "$baseUrl/upload-photo.php", 'host' => ["$baseUrl"], 'path' => ['upload-photo.php']]
                    ]
                ],
                [
                    'name' => '5. Final Register',
                    'request' => [
                        'method' => 'POST',
                        'header' => [
                            ['key' => 'Authorization', 'value' => 'Bearer {{registration_token}}', 'type' => 'text']
                        ],
                        'body' => [
                            'mode' => 'raw',
                            'raw' => "{\n    \"first_name\": \"John\",\n    \"last_name\": \"Doe\",\n    \"birth_date\": \"1995-08-15\",\n    \"gender_identity_id\": 1,\n    \"photo_filenames\": {{photo_filenames}}\n}",
                            'options' => ['raw' => ['language' => 'json']]
                        ],
                        'url' => ['raw' => "$baseUrl/register.php", 'host' => ["$baseUrl"], 'path' => ['register.php']]
                    ]
                ]
            ]
        ],
        
        // FOLDER: Login
        [
            'name' => '2. Authentication',
            'item' => [
                [
                    'name' => '6. Login Send OTP',
                    'request' => [
                        'method' => 'POST',
                        'header' => [],
                        'body' => [
                            'mode' => 'raw',
                            'raw' => "{\n    \"email\": \"{{email}}\"\n}",
                            'options' => ['raw' => ['language' => 'json']]
                        ],
                        'url' => ['raw' => "$baseUrl/login-send-otp.php", 'host' => ["$baseUrl"], 'path' => ['login-send-otp.php']]
                    ]
                ],
                [
                    'name' => '7. Login Verify OTP',
                    'event' => [
                        [
                            'listen' => 'test',
                            'script' => [
                                'exec' => [
                                    'var jsonData = pm.response.json();',
                                    'if (jsonData.data && jsonData.data.auth_token) {',
                                    '    pm.collectionVariables.set("auth_token", jsonData.data.auth_token);',
                                    '}'
                                ],
                                'type' => 'text/javascript'
                            ]
                        ]
                    ],
                    'request' => [
                        'method' => 'POST',
                        'header' => [],
                        'body' => [
                            'mode' => 'raw',
                            'raw' => "{\n    \"email\": \"{{email}}\",\n    \"otp\": \"123456\"\n}",
                            'options' => ['raw' => ['language' => 'json']]
                        ],
                        'url' => ['raw' => "$baseUrl/login-verify-otp.php", 'host' => ["$baseUrl"], 'path' => ['login-verify-otp.php']]
                    ]
                ]
            ]
        ],
        
        // FOLDER: Users
        [
            'name' => '3. Users',
            'item' => [
                [
                    'name' => '8. Get Current User',
                    'request' => [
                        'method' => 'GET',
                        'header' => [
                            ['key' => 'Authorization', 'value' => 'Bearer {{auth_token}}', 'type' => 'text']
                        ],
                        'url' => ['raw' => "$baseUrl/get-current-user.php", 'host' => ["$baseUrl"], 'path' => ['get-current-user.php']]
                    ]
                ],
                [
                    'name' => '9. Get All Users',
                    'request' => [
                        'method' => 'GET',
                        'header' => [
                            ['key' => 'Authorization', 'value' => 'Bearer {{auth_token}}', 'type' => 'text']
                        ],
                        'url' => [
                            'raw' => "$baseUrl/get-all-users.php?page=1&limit=20",
                            'host' => ["$baseUrl"],
                            'path' => ['get-all-users.php'],
                            'query' => [
                                ['key' => 'page', 'value' => '1'],
                                ['key' => 'limit', 'value' => '20']
                            ]
                        ]
                    ]
                ]
            ]
        ],
        
        // FOLDER: Master Data
        [
            'name' => '4. Master Data',
            'item' => [
                [
                    'name' => '10. Get All Master Data',
                    'request' => [
                        'method' => 'GET',
                        'header' => [],
                        'url' => [
                            'raw' => "$baseUrl/master/all-master-data.php",
                            'host' => ["$baseUrl"],
                            'path' => ['master', 'all-master-data.php']
                        ]
                    ]
                ]
            ]
        ]
    ],
    'variable' => [
        ['key' => 'base_url', 'value' => 'http://localhost/dating-api-point/api', 'type' => 'string'],
        ['key' => 'email', 'value' => 'sribashsarkarblp@gmail.com', 'type' => 'string'],
        ['key' => 'registration_token', 'value' => '', 'type' => 'string'],
        ['key' => 'photo_filenames', 'value' => '[]', 'type' => 'string'],
        ['key' => 'auth_token', 'value' => '', 'type' => 'string']
    ]
];

$jsonStr = json_encode($collection, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);

file_put_contents('postman_collection.json', $jsonStr);
file_put_contents('postman-collection2.json', $jsonStr);

echo "Postman collections regenerated successfully.\n";
