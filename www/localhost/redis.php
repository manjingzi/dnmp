<?php

$redis = new Redis();
$redis->connect('redis', 6379);
$redis->set('redis', 'OK');
echo 'redis->' . $redis->get('redis');

