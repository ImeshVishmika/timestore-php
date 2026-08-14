FROM php:8.2-apache

# PHP extensions required by MySQL
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Apache rewrite support for .htaccess
RUN a2enmod rewrite

# Use /public as the web root
RUN sed -ri 's!/var/www/html!/var/www/html/public!g' \
    /etc/apache2/sites-available/000-default.conf \
    /etc/apache2/apache2.conf

# Make sure Apache allows .htaccess
RUN printf '%s\n' \
    '<Directory /var/www/html/public>' \
    '    AllowOverride All' \
    '    Require all granted' \
    '</Directory>' \
    > /etc/apache2/conf-available/public.conf \
    && a2enconf public

COPY . /var/www/html/

CMD ["sh", "-c", "sed -ri \"s/^Listen 80$/Listen ${PORT}/\" /etc/apache2/ports.conf && sed -ri \"s/:80>/:${PORT}>/\" /etc/apache2/sites-available/000-default.conf && apache2-foreground"]