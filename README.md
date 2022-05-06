# PHP8 Templates for OpenFaaS

These templates use `alpine` as base images with PHP8.  
Images are kept as small as possible.

Two templates are included:

* `php8` using the `classic-watchdog` which forks PHP scripts.  
    Base image at 34MB (uncompressed).
* `reactphp` using the `of-watchdog` launching a *ReactPHP* HTTP listener.  
    Base image at 37MB (uncompressed).  
    Find out more of *ReactPHP* at [https://reactphp.org/http/](https://reactphp.org/http/)

## Usage

Retrieve template & create base

```sh
faas-cli template pull https://github.com/choval/faas-php-templates

faas-cli new my-serverless-php-function --lang php8
faas-cli new my-reactphp-function --lang reactphp
```

Files

* `src/handler.php`: the handler function
* `install.sh`: executes shell commands on the image, useful for installing packages and binaries
* `composer.json`: php composer dependencies
* `composer.lock`: optional version locked composer dependencies


## Composer Auth

To pass a composer auth:

```sh
faas-cli build -f ./my-function.yml \
  --build-arg COMPOSER_AUTH=`jq -c . < ./auth.json`
```

With `auth.json` being something like:

```json
{
    "bitbucket-oauth": {
        "bitbucket.org": {
             "consumer-key": "key",
             "consumer-secret": "secret"
        }
    }
}
```
More info: https://getcomposer.org/doc/articles/authentication-for-private-packages.md

