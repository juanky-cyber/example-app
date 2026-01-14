# Usar la imagen PHP 8.2 FPM
FROM php:8.2-fpm 

# 1. Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \ 
    git curl zip unzip libpng-dev libonig-dev libxml2-dev libzip-dev libicu-dev libpq-dev \ 
    nodejs npm \ 
    && docker-php-ext-install pdo pdo_pgsql mbstring zip exif pcntl gd intl \ 
    && apt-get clean && rm -rf /var/lib/apt/lists/* # 2. Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Directorio de trabajo
WORKDIR /var/www 

# Copiar archivos
COPY . . 

# 3. Instalar dependencias de PHP y Node
RUN composer install --optimize-autoloader --no-interaction
RUN npm install && npm run build 

# 4. Permisos
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

# 5. Puerto
EXPOSE 8000 

# 6. COMANDO FINAL (Todo en una línea)
# Espera 10 segundos, migra con datos de prueba y arranca
CMD sh -c "sleep 10 && php artisan migrate:fresh --seed --force && php artisan serve --host=0.0.0.0 --port=8000"