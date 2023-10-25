# Use an official PHP Apache image as the base image
FROM php:7.4-apache
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libmysqlclient-dev

RUN docker-php-ext-install gd gd mysqli

# Set the working directory in the container
WORKDIR /var/www/html

# Copy your PHP application source code into the container
COPY ./src /var/www/html

# Copy your Apache2 configuration files into the container
COPY ./apache-config/000-default.conf /etc/apache2/sites-available/000-default.conf
#COPY ./apache-config/apache2.conf /etc/apache2/apache2.conf
COPY ./php/custom-php.ini /usr/local/etc/php/conf.d/custom-php.ini
# Enable Apache2 modules if needed
RUN a2enmod rewrite
#RUN a2enmod mpm_event
RUN service apache2 restart

# Expose port 80 for Apache
EXPOSE 80

# Start the Apache web server
CMD ["apache2-foreground"]


