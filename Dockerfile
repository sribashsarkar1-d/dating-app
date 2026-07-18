FROM php:8.2-apache

# Install required packages and PHP extensions
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    && docker-php-ext-install pdo pdo_mysql zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy project files to the container
COPY . /var/www/html/

# Install PHP dependencies using Composer
RUN composer install --no-dev --optimize-autoloader

# Set proper permissions for the directories
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# If you have specific writable folders, you can set them here:
# RUN chmod -R 777 /var/www/html/api/uploads
# RUN chmod -R 777 /var/www/html/api/cache
