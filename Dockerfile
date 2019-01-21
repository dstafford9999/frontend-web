FROM ubuntu:18.04

MAINTAINER t3kit

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -yq --no-install-recommends \
    apt-utils \
    curl \
    # Install git
    git \
    # Install apache
    apache2 \
    # Install php 7.2
    libapache2-mod-php7.2 \
    php7.2-cli \
    php7.2-json \
    php7.2-curl \
    php7.2-fpm \
    php7.2-gd \
    php7.2-ldap \
    php7.2-mbstring \
    php7.2-mysql \
    php7.2-soap \
    php7.2-sqlite3 \
    php7.2-xml \
    php7.2-zip \
    php7.2-intl \
    php-imagick \
    # Install tools
    openssl \
    nano \
    graphicsmagick \
    imagemagick \
    ghostscript \
    mysql-client \
    iputils-ping \
    locales \
    sqlite3 \
    apt-transport-https \
    ca-certificates \
    software-properties-common \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

#Update Cert Store
RUN update-ca-certificates

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set locales
RUN locale-gen en_US.UTF-8 en_GB.UTF-8 de_DE.UTF-8 es_ES.UTF-8 fr_FR.UTF-8 it_IT.UTF-8 km_KH sv_SE.UTF-8 fi_FI.UTF-8

RUN a2enmod rewrite expires php7.2

# Configure PHP
ADD php.ini /etc/php/7.2/apache2/conf.d/

# Configure vhost
ADD 00-gibbon.conf /etc/apache2/sites-enabled/00-gibbon.conf

EXPOSE 80 443

WORKDIR /var/www/html

RUN rm index.html

# Create folders
RUN mkdir /var/www/html/gibbon

#Get Gibbon 17
RUN git clone https://github.com/GibbonEdu/core.git /var/www/html/gibbon

# Copy config.php
ADD config.php /var/www/html/gibbon

# Set permissions of all site files so they are not publicly writeable
RUN chmod -R 755 /var/www/html/gibbon
RUN chown -R www-data:www-data /var/www/html/gibbon
RUN chmod -R 766 /var/www/html/gibbon/uploads
RUN chown -R www-data:www-data /var/www/html/gibbon/uploads

# By default start up apache in the foreground, override with /bin/bash for interactive.
CMD ["apache2ctl", "-D", "FOREGROUND"]
