FROM debian:jessie

ARG BUILD_PHP_VERSION="master"
ARG BUILD_GPG_KEYS=""
ARG BUILD_PHP_SHA256=""
ARG BUILD_CHECK_SIGNATURE=false
ARG BUILD_CUSTOM_URL=''
ARG BUILD_REPO_URL='https://github.com/php/php-src/archive/master.zip'

ENV PHPIZE_DEPS \
        autoconf \
        dpkg-dev \
        file \
        g++ \
        gcc \
        libc-dev \
        lcov \
        libpcre3-dev \
        make \
        pkg-config \
        re2c \
        build-essential \
        wget \
        curl \
        git \
        vim \
        autoconf \
        software-properties-common \
        mm-common \
        libreadline-dev \
        libxslt1-dev \
        re2c \
        libpng-dev \
        libjpeg-dev \
        m4 \
        lcov \
        libicu-dev \
        libc-bin \
        tzdata \
        initscripts \
        libedit2 \
        libonig2 \
        libqdbm14 \
        bison \
        snmp \
        libbison-dev \
        libxml2-dev \
        libevent-dev \
        zlib1g-dev \
        libbz2-dev \
        libgmp3-dev \
        libssl-dev \
        libjpeg-dev \
        libpng-dev \
        libxpm-dev \
        libgd2-xpm-dev \
        libmcrypt-dev \
        memcached \
        libmemcached-dev \
        libpcre3-dev \
        libc-client-dev \
        libkrb5-dev \
        libsasl2-dev \
        libmysqlclient-dev \
        libpspell-dev \
        libsnmp-dev \
        libxslt-dev \
        libtool \
        libc-client2007e \
        libc-client2007e-dev \
        libenchant-dev \
        libgmp-dev \
        librecode-dev \
        libmm-dev \
        libmm14 \
        libzip-dev \
        libedit-dev
ENV PHP_INI_DIR /usr/local/etc/php
ENV PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2"
ENV PHP_CPPFLAGS="$PHP_CFLAGS"
ENV PHP_LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie"
ENV GPG_KEYS="$BUILD_GPG_KEYS"
ENV PHP_VERSION="$BUILD_PHP_VERSION"
ENV PHP_URL="https://secure.php.net/get/php-$PHP_VERSION.tar.xz/from/this/mirror"
ENV PHP_ASC_URL="https://secure.php.net/get/php-$PHP_VERSION.tar.xz.asc/from/this/mirror"
ENV PHP_SHA256="$BUILD_PHP_SHA256"
ENV CHECK_SIGNATURE="$BUILD_CHECK_SIGNATURE"
ENV CUSTOM_URL="$BUILD_CUSTOM_URL"
ENV REPO_URL="$BUILD_REPO_URL"

RUN ln -fs /usr/include/linux/igmp.h /usr/include/gmp.h
RUN ln -fs /usr/lib/i386-linux-gnu/libldap.so /usr/lib/


RUN apt-get update && apt-get install -y \
        $PHPIZE_DEPS \
        ca-certificates \
        curl \
        libedit2 \
        libsqlite3-0 \
        libxml2 \
        xz-utils \
    --no-install-recommends && rm -r /var/lib/apt/lists/*

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
    if [ -n "$REPO_URL" ]; then \
        wget -O php-src-master.zip "$REPO_URL"; \
    elif [ -n "$CUSTOM_URL" ]; then \
        wget -O php.tar.xz "$CUSTOM_URL"; \
    else \
        wget -O php.tar.xz "$PHP_URL"; \
    fi; \
    if [ -n "$PHP_SHA256" ] && [ "$CHECK_SIGNATURE" = "true" ]; then \
        echo "$PHP_SHA256 *php.tar.xz" | sha256sum -c -; \
    fi; \
    if [ -n "$PHP_ASC_URL" ] && [ "$CHECK_SIGNATURE" = "true" ]; then \
        wget -O php.tar.xz.asc "$PHP_ASC_URL"; \
        export GNUPGHOME="$(mktemp -d)"; \
        for key in $GPG_KEYS; do \
            gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
        done; \
        gpg --batch --verify php.tar.xz.asc php.tar.xz; \
        rm -r "$GNUPGHOME"; \
    fi;

COPY scripts/docker-php-* /usr/local/bin/

RUN set -xe \
    && buildDeps=" \
    $PHP_EXTRA_BUILD_DEPS \
    libcurl4-openssl-dev \
    libedit-dev \
    libsqlite3-dev \
    libssl-dev \
    libxml2-dev \
    build-essential \
    autoconf \
    automake \
    libtool \
    bison \
    re2c \
    " \
    && apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
    && export CFLAGS="$PHP_CFLAGS" \
        CPPFLAGS="$PHP_CPPFLAGS" \
        LDFLAGS="$PHP_LDFLAGS"

RUN docker-php-source extract \
    && cd /usr/src/php \
    && gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && debMultiarch="$(dpkg-architecture --query DEB_BUILD_MULTIARCH)" \
    && if [ -n "$REPO_URL" ]; then ./buildconf; fi \
    && ./configure \
        --build="$gnuArch" \
        --with-config-file-path="$PHP_INI_DIR" \
        --with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
        --enable-gcov \
        --enable-debug \
        --enable-sigchild \
        --enable-libgcc \
        --with-openssl \
        --with-kerberos \
        --with-pcre-regex \
        --enable-bcmath \
        --with-bz2 \
        --enable-calendar \
        --with-curl \
        --with-enchant \
        --enable-exif \
        --enable-ftp \
        --with-gd \
        --enable-gd-jis-conv \
        --with-gettext \
        --with-mhash \
        --with-kerberos \
        --with-imap-ssl \
        --enable-intl \
        --enable-mbstring \
        --with-onig \
        --with-pspell \
        --with-recode \
        --with-mm \
        --enable-shmop \
        --with-snmp \
        --enable-soap \
        --enable-sockets \
        --enable-sysvsem \
        --enable-wddx \
        --with-xmlrpc \
        --with-xsl \
        --enable-zip \
        --with-readline \
        --with-libedit \
        --enable-ftp \
        --enable-mbstring \
        --enable-mysqlnd \
        --with-libedit \
        --with-zlib \
        --with-pcre-regex=/usr \
        --with-libdir="lib/$debMultiarch" \
        $PHP_EXTRA_CONFIGURE_ARGS \
    && make -j "$(nproc)" \
    && make install \
    && { find /usr/local/bin /usr/local/sbin -type f -executable -exec strip --strip-all '{}' + || true; } \
    && cd / \
    && pecl update-channels \
    && rm -rf /tmp/pear ~/.pearrc \
    && apt-get purge -y --auto-remove $fetchDeps

RUN cd /usr/src/php/scripts/dev \
    && rm generate-phpt.phar \
    && php -d phar.readonly=0 generate-phpt/gtPackage.php \
    && cd /

WORKDIR /usr/src/php/
CMD ["/bin/bash"]
