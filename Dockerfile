FROM php:8.2-apache

# Install required PHP extensions
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Enable rewrite module
RUN a2enmod rewrite

# Ensure only one MPM is loaded (fixes "More than one MPM loaded" on Railway)
RUN a2dismod mpm_event mpm_worker 2>/dev/null; a2enmod mpm_prefork

# Update document root to /public
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
    && sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Configure directory permissions for .htaccess
RUN printf '%s\n' \
    '<Directory /var/www/html/public>' \
    '    AllowOverride All' \
    '    Require all granted' \
    '</Directory>' \
    > /etc/apache2/conf-available/public.conf \
    && a2enconf public

# Copy project files
COPY . /var/www/html/

# Bind Apache dynamically to Railway's assigned $PORT
CMD ["sh", "-c", "sed -ri \"s/^Listen 80$/Listen ${PORT:-80}/\" /etc/apache2/ports.conf && sed -ri \"s/:80>/:${PORT:-80}>/\" /etc/apache2/sites-available/000-default.conf && apache2-foreground"]