<?php
$query = $_SERVER['Http_Query'] ?? '';
parse_str($query, $get);
$name = $get['name'] ?? 'world';
echo "Hello $name\n";
