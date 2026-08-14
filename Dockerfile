FROM php:8.2-apache

# Enable Apache rewrite module
RUN a2enmod rewrite

# Set document root to /public
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public

# Change Apache document root
RUN sed -ri \
    -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' \
    /etc/apache2/sites-available/000-default.conf

# Allow .htaccess and access to public directory
RUN printf '%s\n' \
    '<Directory /var/www/html/public>' \
    '    AllowOverride All' \
    '    Require all granted' \
    '</Directory>' \
    > /etc/apache2/conf-available/public.conf \
    && a2enconf public

# Copy application
COPY . /var/www/html/

# Railway uses the PORT environment variable
CMD ["sh", "-c", "sed -i \"s/Listen 80/Listen ${PORT}/\" /etc/apache2/ports.conf && sed -i \"s/:80>/:${PORT}>/\" /etc/apache2/sites-available/000-default.conf && apache2-foreground"]