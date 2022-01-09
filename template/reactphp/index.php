<?php

require __DIR__ . '/function/vendor/autoload.php';
require __DIR__ . '/function/src/handler.php';

$http = new React\Http\HttpServer(function (Psr\Http\Message\ServerRequestInterface $request) {
    return handler($request);
});

$socket = new React\Socket\SocketServer('127.0.0.1:3000');
$http->listen($socket);

