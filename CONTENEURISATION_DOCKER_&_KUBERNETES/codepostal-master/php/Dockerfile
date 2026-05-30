FROM php:8.4-apache

RUN docker-php-ext-install pdo_mysql
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY php-timezone.ini /usr/local/etc/php/conf.d/
COPY php-browscap.ini /usr/local/etc/php/conf.d/


# Get browscap.ini to analyze user agents
RUN curl -o /usr/local/etc/php/conf.d/browscap.ini https://browscap.org/stream?q=PHP_BrowsCapINI

COPY www/* /var/www/html/

