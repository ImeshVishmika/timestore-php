FROM php:8.2-apache

# PHP extensions required by MySQL
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Enable rewrite & ensure only prefork MPM is loaded
RUN a2dismod mpm_event mpm_worker || true \
    && a2enmod mpm_prefork rewrite

# Use /public as the web root
RUN sed -ri 's!/var/www/html!/var/www/html/public!g' \
    /etc/apache2/sites-available/000-default.conf \
    /etc/apache2/apache2.conf

# Make sure Apache allows .htaccess in /public
RUN printf '%s\n' \
    '<Directory /var/www/html/public>' \
    '    AllowOverride All' \
    '    Require all granted' \
    '</Directory>' \
    > /etc/apache2/conf-available/public.conf \
    && a2enconf public

COPY . /var/www/html/

# Bind Apache dynamically to $PORT (defaulting to 80 if PORT is unset)
CMD ["sh", "-c", "PORT=${PORT:-80}; sed -ri \"s/^Listen .*/Listen ${PORT}/\" /etc/apache2/ports.conf && sed -ri \"s/<VirtualHost \\*:[0-9]+>/<VirtualHost *:${PORT}>/\" /etc/apache2/sites-available/000-default.conf && apache2-foreground"]