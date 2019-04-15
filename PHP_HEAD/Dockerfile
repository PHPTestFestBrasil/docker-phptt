FROM debian:stretch

ARG USER_PUID=1000
ARG USER_PGID=1000
ARG USER_NAME=php

RUN groupadd --gid $USER_PGID $USER_NAME \
    && useradd --uid $USER_PUID --gid $USER_NAME -m $USER_NAME

ENV PHPIZE_DEPS \
    autoconf \
    dpkg-dev \
    file \
    g++ \
    gcc \
    libc-dev \
    libpcre3-dev \
    make \
    pkg-config \
    re2c \
    libedit2 \
    libsqlite3-0 \
    libxml2 \
    xz-utils \
    build-essential \
    wget \
    curl \
    git \
    vim \
    software-properties-common \
    locales \
    libgmp-dev \
    libicu-dev \
    libtidy-dev \
    libenchant-dev \
    libaspell-dev \
    libpspell-dev \
    librecode-dev \
    libsasl2-dev \
    libxpm-dev \
    libzip-dev \
    mm-common \
    libssl-dev \
    libreadline-dev \
    libxslt1-dev \
    libpng-dev \
    libjpeg-dev \
    m4 \
    lcov \
    libc-bin \
    tzdata \
    initscripts \
    libqdbm14 \
    bison \
    snmp \
    libxml2-dev \
    libevent-dev \
    zlib1g-dev \
    libbz2-dev \
    libgmp3-dev \
    libgd2-xpm-dev \
    libmcrypt-dev \
    memcached \
    libmemcached-dev \
    libc-client-dev \
    libkrb5-dev \
    libsnmp-dev \
    libxslt-dev \
    libtool \
    libc-client2007e \
    libc-client2007e-dev \
    libmm-dev \
    libmm14 \
    libedit-dev \
    libbison-dev \
    libonig-dev \
    dpkg-dev \
    libpq-dev \
    unixodbc-dev \
    unixodbc-dev \
    valgrind \
    libdb-dev \
    libgdm-dev \
    libgdbm-dev \
    libfbclient2 \
    firebird-dev \
    ldap-utils \
    libldap-dev \
    freetds-dev

ENV PHP_INI_DIR /usr/local/etc/php
ENV PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2"
ENV PHP_CPPFLAGS="$PHP_CFLAGS"
ENV PHP_LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie"

RUN apt-get update && apt-get install -y \
    $PHPIZE_DEPS \
    ca-certificates \
    --no-install-recommends && rm -r /var/lib/apt/lists/*

RUN ln -fs /usr/lib/x86_64-linux-gnu/libsybdb.so /usr/lib/libsybdb.so
RUN ln -fs /usr/include/linux/igmp.h /usr/include/gmp.h
RUN ln -fs /usr/lib/i386-linux-gnu/libldap.so /usr/lib/

RUN mkdir -p $PHP_INI_DIR/conf.d
RUN set -xe; \
    \
    fetchDeps=' \
    wget \
    unzip \
    '; \
    apt-get update; \
    apt-get install -y --no-install-recommends $fetchDeps; \
    rm -rf /var/lib/apt/lists/*; \
    mkdir -p /usr/src; \
    cd /usr/src; \
    wget -O php-src-master.zip https://github.com/php/php-src/archive/master.zip;

COPY docker-php-source /usr/local/bin/

RUN set -xe \
    && buildDeps=" \
    $PHP_EXTRA_BUILD_DEPS \
    libcurl4-openssl-dev \
    libsqlite3-dev \
    automake \
    " \
    && apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
    && export CFLAGS="$PHP_CFLAGS" \
    CPPFLAGS="$PHP_CPPFLAGS" \
    LDFLAGS="$PHP_LDFLAGS"

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
    --with-xsl \
    --enable-wddx \
    --with-tidy \
    --enable-soap \
    --with-bz2 \
    --with-imap \
    --with-imap-ssl \
    --with-kerberos \
    --with-mysqli=mysqlnd \
    --with-openssl \
    --with-pdo-mysql=mysqlnd \
    --with-pdo-sqlite \
    --with-pgsql \
    --with-pdo-pgsql \
    --with-zlib \
    --enable-bcmath \
    --enable-calendar \
    --enable-dba \
    --enable-exif \
    --enable-ftp \
    --with-gd \
    --with-gmp \
    --enable-pcntl \
    --enable-shmop \
    --enable-sockets \
    --enable-sysvmsg \
    --enable-sysvsem \
    --enable-sysvshm \
    --with-xmlrpc \
    --with-snmp \
    --enable-mbstring \
    --with-gdbm \
    --with-pdo-firebird \
    --with-gettext \
    --with-readline \
    --enable-intl \
    --with-mhash \
    --with-unixODBC=/usr \
    --with-pdo-odbc=unixODBC,/usr \
    --with-pdo-dblib \
    --with-litespeed \
    --with-interbase \
    --with-pcre-valgrind \
    --enable-debug \
    --enable-sigchild \
    --enable-libgcc \
    --with-pcre-regex \
    --enable-gd-jis-conv \
    --with-onig \
    --with-mm \
    --enable-zip \
    --with-libedit \
    --enable-phpdbg \
    --enable-fpm \
    --with-jpeg-dir=/usr \
    --with-png-dir=/usr \
    --without-libzip \
    --with-zlib-dir=/usr \
    --enable-xmlreader \
    --with-curl=/usr \
    --with-pspell=/usr \
    --with-enchant=/usr \
    --with-freetype-dir=/usr \
    --with-xpm-dir=/usr \
    --enable-zend-test \
    $PHP_EXTRA_CONFIGURE_ARGS \
    && make -j "$(nproc)" \
    && make install \
    && { find /usr/local/bin /usr/local/sbin -type f -executable -exec strip --strip-all '{}' + || true; } \
    && cd / \
    && pecl update-channels \
    && rm -rf /tmp/pear ~/.pearrc 
    
RUN chown -R $USER_NAME.$USER_NAME /usr/src/

WORKDIR /usr/src/php/
CMD ["/bin/bash"]
