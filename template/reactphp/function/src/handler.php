<?php
use React\Http\Message\Response;

function handler(Psr\Http\Message\ServerRequestInterface $req) {
    $get = $req->getQueryParams();
    $name = $get['name'] ?? 'world';
    $msg = "Hello {$name}";
    return Response::plaintext($msg);
}

