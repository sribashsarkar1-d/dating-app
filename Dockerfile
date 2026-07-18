FROM php:8.2-apache

# Install required PHP extensions
RUN docker-php-ext-install pdo pdo_mysql

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy project files to the container
COPY . /var/www/html/

# Set proper permissions for the uploads and cache directories
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# If you have specific writable folders, you can set them here:
# RUN chmod -R 777 /var/www/html/api/uploads
# RUN chmod -R 777 /var/www/html/api/cache
