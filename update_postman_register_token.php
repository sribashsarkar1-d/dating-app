<?php
$files = ['postman_collection.json', 'postman-collection2.json'];

foreach ($files as $file) {
    if (!file_exists($file)) continue;
    
    $json = json_decode(file_get_contents($file), true);
    
    // Find Final Register
    foreach ($json['item'] as &$folder) {
        if ($folder['name'] === '1. Registration') {
            foreach ($folder['item'] as &$req) {
                if ($req['name'] === '5. Final Register') {
                    // Add event script
                    $req['event'] = [
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
                    ];
                }
            }
        }
    }
    
    file_put_contents($file, json_encode($json, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES));
}

echo "Postman updated.\n";
