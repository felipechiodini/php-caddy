FROM php:8.2-fpm-alpine as php-system-setup

# Instala dependências e Caddy
RUN apk add --no-cache libzip-dev zip unzip dcron busybox-suid libcap curl \
    && docker-php-ext-install pdo pdo_mysql opcache

COPY --from=ochinchina/supervisord:latest /usr/local/bin/supervisord /usr/local/bin/supervisord

COPY --from=caddy:2.2.1 /usr/bin/caddy /usr/local/bin/caddy

COPY --from=composer/composer:2 /usr/bin/composer /usr/local/bin/composer

FROM php-system-setup AS app-setup

WORKDIR /var/www/html
COPY . /var/www/html

COPY ./etc/php.ini /usr/local/etc/php/conf.d/php.ini 

EXPOSE 80

ENTRYPOINT ["sh", "/var/www/html/etc/entrypoint.sh"]