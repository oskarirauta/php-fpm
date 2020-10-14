FROM alpine:latest

ARG VERSION

# Environments
ENV MEMORY_LIMIT=256M \
    MAX_EXECUTION_TIME=60 \
    UPLOAD_MAX_FILESIZE=64M \
    MAX_FILE_UPLOADS=20 \
    POST_MAX_SIZE=64M \
    MAX_INPUT_VARS=4000 \
    DATE_TIMEZONE=Europe/Helsinki \
    PM_MAX_CHILDREN=6 \
    PM_START_SERVERS=4 \
    PM_MIN_SPARE_SERVERS=2 \
    PM_MAX_SPARE_SERVERS=6 \
    UID=82 \
    GID=82

# Let's roll
RUN set -xe && \
    apk add --no-cache \
        php7-bcmath \
        php7-bz2 \
        php7-curl \
        php7-ctype \
        php7-dom \
        php7-exif \
        php7-fileinfo \
        php7-gd \
        php7-gettext \
        php7-gmp \
        php7-iconv \
        php7-json \
        php7-mbstring \
        php7-mysqli \
        php7-mysqlnd \
        php7-odbc \
        php7-opcache \
        php7-openssl \
        php7-pecl-imagick \
        php7-pdo \
        php7-pdo_dblib \
        php7-pdo_mysql \
        php7-pdo_odbc \
        php7-pdo_pgsql \
        php7-pdo_sqlite \
        php7-session \
        php7-simplexml \
        php7-soap \
        php7-sodium \
        php7-sqlite3 \
        php7-xmlreader \
        php7-xmlrpc \
        php7-zip \
        php7-fpm \
        php7

RUN set -eux; \
	addgroup -g 82 -S www-data; \
	adduser -u 82 -D -S -G www-data -g www www; \
	mkdir -p /var/www; \
	chown -R www:www-data /var/www
	
RUN set -eux; \
	mkdir -p /docker-entrypoint.d /scripts /etc/php7/templates /etc/php7/templates/php-fpm.d; \
	mv /etc/php7/php-fpm.conf /etc/php7/templates/; \
	mv /etc/php7/php-fpm.d/www.conf /etc/php7/templates/php-fpm.d/; \
	mv /etc/php7/php.ini /etc/php7/templates/

COPY entrypoint.sh /scripts/docker-entrypoint.sh

VOLUME ["/var/www"]
EXPOSE 9000

WORKDIR /var/www
ENTRYPOINT ["/scripts/docker-entrypoint.sh"]
CMD ["/usr/sbin/php-fpm7"]
