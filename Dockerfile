# base this image on the PHP image that comes with Apache https://hub.docker.com/_/php/
FROM php:7.2-apache

# install mysql-client and curl for our data init script
# install the PHP extension pdo_mysql for our connection script
# clean up
RUN apt-get update \
  && apt-get install -y mysql-client curl \
  && docker-php-ext-install pdo_mysql apt-utils \
  && apt-get clean autoclean \
  && apt-get autoremove \
  && rm -rf /var/cache/apt/archives \
  && rm -rf /var/lib/apt/lists/* \
  && /var/lib/dpkg/* \
  && /var/lib/cache/* \
  && /var/lib/log/* \
  && mkdir /var/www/html/gibbon


RUN curl -SL https://github.com/GibbonEdu/core/archive/v17.0.00.zip \
    | unzip v17.0.00.zip -d /var/www/html/gibbon \
    && make -C /usr/src/things all


# copy-config-files
COPY config.php /var/www/html/gibbon/
COPY 00-gibbon.conf /etc/apache2/sites-enabled/
COPY php.ini /etc/php/7.2/apache2/
