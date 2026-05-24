FROM php:8.2-apache

RUN a2enmod rewrite \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    libpq-dev \
  && docker-php-ext-install pdo_mysql pdo_pgsql \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html
COPY php/www/ /var/www/html/

COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
