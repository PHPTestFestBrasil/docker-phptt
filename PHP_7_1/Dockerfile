FROM debian:stretch-slim

RUN groupadd --gid 1000 php \
    && useradd --uid 1000 --gid php -m php

RUN set -eux; \
    { \
        echo 'Package: php*'; \
        echo 'Pin: release *'; \
        echo 'Pin-Priority: -1'; \
} > /etc/apt/preferences.d/no-debian-php

ENV PHP_INI_DIR="/usr/local/etc/php"
ENV PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2"
ENV PHP_CPPFLAGS="$PHP_CFLAGS"
ENV PHP_LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie"
ENV PHPIZE_DEPS \
    autoconf \
    dpkg-dev \
    file \
    g++ \
    gcc \
    libc-dev \
    make \
    pkg-config \
    bison \
    re2c \
    lcov \
    valgrind \
    libxslt1-dev \
    libtidy-dev \
    libbz2-dev \
    libc-client2007e-dev \
    libkrb5-dev \
    libpq-dev \
    libonig-dev \
    libzip-dev \
    libgmp-dev \
    libgdbm-dev \
    firebird-dev \
    libreadline-dev \
    unixodbc-dev \
    freetds-dev \
    libpcre3-dev \
    libmm-dev \
    libenchant-dev \
    libpspell-dev

RUN apt-get update \
    && apt-get install -y \
    $PHPIZE_DEPS \
    ca-certificates \
    curl \
    --no-install-recommends && rm -r /var/lib/apt/lists/*

RUN set -eux; \
    ln -fs /usr/lib/x86_64-linux-gnu/libsybdb.so /usr/lib/libsybdb.so; \
    mkdir -p "$PHP_INI_DIR/conf.d"

RUN set -xe; \
    fetchDeps=' \
    wget \
    unzip \
    '; \
    apt-get update; \
    apt-get install -y --no-install-recommends $fetchDeps; \
    rm -rf /var/lib/apt/lists/*; \
    mkdir -p /usr/src; \
    cd /usr/src; \
    wget -O php-src-PHP-7.1.zip https://github.com/php/php-src/archive/PHP-7.1.zip;

COPY docker-php-source /usr/local/bin/

RUN set -eux; \
    savedAptMark="$(apt-mark showmanual)"; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        libcurl4-gnutls-dev \
        libedit-dev \
        libsodium-dev \
        libsqlite3-dev \
        libssl-dev \
        libxml2-dev \
        zlib1g-dev \
    ; \
    sed -e 's/stretch/buster/g' /etc/apt/sources.list > /etc/apt/sources.list.d/buster.list; \
    { \
        echo 'Package: *'; \
        echo 'Pin: release n=buster'; \
        echo 'Pin-Priority: -10'; \
        echo; \
        echo 'Package: libargon2*'; \
        echo 'Pin: release n=buster'; \
        echo 'Pin-Priority: 990'; \
    } > /etc/apt/preferences.d/argon2-buster; \
    apt-get update; \
    apt-get install -y --no-install-recommends libargon2-dev; \
    rm -rf /var/lib/apt/lists/*; \
    export \
        CFLAGS="$PHP_CFLAGS" \
        CPPFLAGS="$PHP_CPPFLAGS" \
        LDFLAGS="$PHP_LDFLAGS";            


RUN docker-php-source extract \
    && cd /usr/src/php \
    && gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && debMultiarch="$(dpkg-architecture --query DEB_BUILD_MULTIARCH)" \
    && ./buildconf \
    && ./configure \
        --build="$gnuArch" \
        --with-config-file-path="$PHP_INI_DIR" \
        --with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
        --enable-gcov \
        --enable-soap \
        --enable-bcmath \
        --enable-calendar \
        --enable-dba \
        --enable-exif \
        --enable-ftp \
        --enable-pcntl \
        --enable-shmop \
        --enable-sockets \
        --enable-sysvmsg \
        --enable-sysvsem \
        --enable-sysvshm \
        --enable-mbstring \
        --enable-intl \
        --enable-sigchild \
        --enable-libgcc \
        --enable-gd-jis-conv \
        --enable-zip \
        --enable-debug \
        --enable-phpdbg \
        --enable-fpm \
        --enable-xmlreader \
        --enable-zend-test \
        --with-xsl \
        --with-tidy \
        --with-bz2 \
        --with-imap \
        --with-imap-ssl \
        --with-kerberos \
        --with-openssl \
        --with-mysqli=mysqlnd \
        --with-pdo-mysql=mysqlnd \
        --with-pdo-sqlite \
        --with-pgsql \
        --with-pdo-pgsql \
        --with-zlib \
        --with-gmp \
        --with-xmlrpc \
        --with-gdbm \
        --with-pdo-firebird \
        --with-gettext \
        --with-readline \
        --with-mhash \
        --with-unixODBC=/usr \
        --with-pdo-odbc=unixODBC,/usr \
        --with-pdo-dblib \
        --with-interbase \
        --with-pcre-valgrind \
        --with-mm \
        --with-pspell=/usr \
        --with-enchant=/usr \
        --with-libedit \
        --with-litespeed \
        --with-libzip \
        --with-zlib-dir=/usr \
        --with-curl=/usr \
        $(test "$gnuArch" = 's390x-linux-gnu' && echo '--without-pcre-jit') \
    && make -j "$(nproc)" \
    && make install \
    && { find /usr/local/bin /usr/local/sbin -type f -executable -exec strip --strip-all '{}' + || true; } \
    && rm -rf /usr/src/php-src-master.zip \
    && chown -R php.php /usr/src/php \
    && rm -rf /tmp/pear ~/.pearrc \
    && echo 'phar.readonly = Off' >> ${PHP_INI_DIR}/php.ini

USER php

RUN mkdir -p /home/php/phptt \
    && cd /home/php/phptt \
    && wget https://github.com/royopa/generate-phpt/archive/master.zip -O generate-phpt.zip \
    && unzip generate-phpt.zip \
    && rm -rf generate-phpt.zip \
    && php generate-phpt-master/create-phar.php \
    && mv generate-phpt-master/build/generate-phpt.phar /usr/src/php/scripts/dev/ \
    && rm -rf generate-phpt-master

WORKDIR /usr/src/php/

CMD ["/bin/bash"]