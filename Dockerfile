FROM serversideup/php:8.3-frankenphp
USER root
RUN install-php-extensions imagick gmp intl redis exif zip
USER www-data
