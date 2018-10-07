FROM debian:jessie

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
	wget -O php-src-PHP-7.1.zip https://github.com/php/php-src/archive/PHP-7.1.zip;

COPY docker-php-source /usr/local/bin/

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
	&& ./buildconf \
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

RUN chown -R $USER_NAME.$USER_NAME /usr/src/

WORKDIR /usr/src/php/
CMD ["/bin/bash"]
