FROM php:7.2-apache
RUN apt-get update \
  && apt-get install -y mysql-client curl \
  && docker-php-ext-install pdo_mysql \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives

# copy-config-files
COPY 00-gibbon.conf /etc/apache2/sites-enabled/
COPY php.ini /etc/php/7.2/apache2/
