<?php
date_default_timezone_set('{{timezone}}');

$script_tz = date_default_timezone_get();

if (strcmp($script_tz, ini_get('date.timezone'))){
    echo 'Die Script-Zeitzone unterscheidet sich von der ini-set Zeitzone.';
} else {
    echo 'Die Script-Zeitzone und die ini-set Zeitzone stimmen überein.';
}
?>

