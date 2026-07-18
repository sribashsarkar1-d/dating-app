<?php
$c=file_get_contents('dating-app.sql');
preg_match_all('/CREATE TABLE `(.*?)` \([\s\S]*?\) ENGINE/', $c, $m);
$tables = ['user_profiles', 'user_photos', 'user_match_preferences', 'email_verifications', 'otps', 'education_levels', 'religions', 'political_views', 'registration_tokens', 'users', 'user_preference_children', 'user_preference_languages', 'user_preference_pets', 'user_preference_politics', 'user_hobbies', 'user_interests', 'user_languages'];
foreach($m[0] as $i=>$t){
    if(in_array($m[1][$i], $tables)) {
        echo $t . "\n\n";
    }
}
