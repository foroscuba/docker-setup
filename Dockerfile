FROM serversideup/php:8.4-fpm-nginx

USER root

RUN install-php-extensions gd mysqli intl imagick exif zip gmp redis

USER www-data
