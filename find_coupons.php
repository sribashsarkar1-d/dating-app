<?php
$content = file_get_contents('dating-app (3).sql');
if (preg_match('/CREATE TABLE `coupons`(.*?)ENGINE/is', $content, $matches)) {
    echo $matches[0];
} else {
    echo "Not found";
}
