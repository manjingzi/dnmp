#!/bin/sh

export MC="-j$(nproc)"

# debug:0; info:1; warn:2; error:3
LOG_LEVEL=0

function record_log() {
    local type=$1
    local content=$2
    case $type in
    debug)
        [[ $LOG_LEVEL -le 0 ]] && echo -e "\033[34m${content}\033[0m"
        ;;
    info)
        [[ $LOG_LEVEL -le 1 ]] && echo -e "\033[32m${content}\033[0m"
        ;;
    warn)
        [[ $LOG_LEVEL -le 2 ]] && echo -e "\033[33m${content}\033[0m"
        ;;
    error)
        [[ $LOG_LEVEL -le 3 ]] && echo -e "\033[31m${content}\033[0m"
        ;;
    esac
}

record_log info ""
record_log info "===================================================================================="
record_log info "Install extensions from   : install.sh"
record_log info "PHP version               : ${PHP_VERSION}"
record_log info "Extra Extensions          : ${PHP_EXTENSIONS}"
record_log info "Multicore Compilation     : ${MC}"
record_log info "Container package url     : ${CONTAINER_PACKAGE_URL}"
record_log info "Work directory            : ${PWD}"
record_log info "==================================================================================="
record_log info ""


if [ "${PHP_EXTENSIONS}" != "" ]; then
    apk --update add --no-cache --virtual .build-deps autoconf g++ libtool make curl-dev gettext-dev linux-headers
fi


export EXTENSIONS=",${PHP_EXTENSIONS},"


#
# Check if current php version is greater than or equal to
# specific version.
#
# For example, to check if current php is greater than or
# equal to PHP 7.0:
#
# isPhpVersionGreaterOrEqual 7 0
#
# Param 1: Specific PHP Major version
# Param 2: Specific PHP Minor version
# Return : 1 if greater than or equal to, 0 if less than
#
isPhpVersionGreaterOrEqual()
 {
    local PHP_MAJOR_VERSION=$(php -r "echo PHP_MAJOR_VERSION;")
    local PHP_MINOR_VERSION=$(php -r "echo PHP_MINOR_VERSION;")

    if [[ "$PHP_MAJOR_VERSION" -gt "$1" || "$PHP_MAJOR_VERSION" -eq "$1" && "$PHP_MINOR_VERSION" -ge "$2" ]]; then
        return 1;
    else
        return 0;
    fi
}


#
# Install extension from package file(.tgz),
# For example:
#
# installExtensionFromTgz redis-5.0.2
#
# Param 1: Package name with version
# Param 2: enable options
#
installExtensionFromTgz()
{
    tgzName=$1
    extensionName="${tgzName%%-*}"

    mkdir ${extensionName}
    tar -xf ${tgzName}.tgz -C ${extensionName} --strip-components=1
    ( cd ${extensionName} && phpize && ./configure && make ${MC} && make install )

    docker-php-ext-enable ${extensionName} $2
}


if [[ -z "${EXTENSIONS##*,pdo_mysql,*}" ]]; then
    record_log info "---------- Install pdo_mysql ----------"
    docker-php-ext-install ${MC} pdo_mysql
fi

if [[ -z "${EXTENSIONS##*,pcntl,*}" ]]; then
    record_log info "---------- Install pcntl ----------"
	docker-php-ext-install ${MC} pcntl
fi

if [[ -z "${EXTENSIONS##*,mysqli,*}" ]]; then
    record_log info "---------- Install mysqli ----------"
	docker-php-ext-install ${MC} mysqli
fi

if [[ -z "${EXTENSIONS##*,exif,*}" ]]; then
    record_log info "---------- Install exif ----------"
	docker-php-ext-install ${MC} exif
fi

if [[ -z "${EXTENSIONS##*,bcmath,*}" ]]; then
    record_log info "---------- Install bcmath ----------"
	docker-php-ext-install ${MC} bcmath
fi

if [[ -z "${EXTENSIONS##*,calendar,*}" ]]; then
    record_log info "---------- Install calendar ----------"
	docker-php-ext-install ${MC} calendar
fi

if [[ -z "${EXTENSIONS##*,zend_test,*}" ]]; then
    record_log info "---------- Install zend_test ----------"
	docker-php-ext-install ${MC} zend_test
fi

if [[ -z "${EXTENSIONS##*,opcache,*}" ]]; then
    record_log info "---------- Install opcache ----------"
    docker-php-ext-install opcache
fi

if [[ -z "${EXTENSIONS##*,sockets,*}" ]]; then
    record_log info "---------- Install sockets ----------"
	docker-php-ext-install ${MC} sockets
fi

if [[ -z "${EXTENSIONS##*,gettext,*}" ]]; then
    record_log info "---------- Install gettext ----------"
	docker-php-ext-install ${MC} gettext
fi

if [[ -z "${EXTENSIONS##*,shmop,*}" ]]; then
    record_log info "---------- Install shmop ----------"
	docker-php-ext-install ${MC} shmop
fi

if [[ -z "${EXTENSIONS##*,sysvmsg,*}" ]]; then
    record_log info "---------- Install sysvmsg ----------"
	docker-php-ext-install ${MC} sysvmsg
fi

if [[ -z "${EXTENSIONS##*,sysvsem,*}" ]]; then
    record_log info "---------- Install sysvsem ----------"
	docker-php-ext-install ${MC} sysvsem
fi

if [[ -z "${EXTENSIONS##*,sysvshm,*}" ]]; then
    record_log info "---------- Install sysvshm ----------"
	docker-php-ext-install ${MC} sysvshm
fi

if [[ -z "${EXTENSIONS##*,pdo_firebird,*}" ]]; then
    record_log info "---------- Install pdo_firebird ----------"
	docker-php-ext-install ${MC} pdo_firebird
fi

if [[ -z "${EXTENSIONS##*,pdo_dblib,*}" ]]; then
    record_log info "---------- Install pdo_dblib ----------"
	docker-php-ext-install ${MC} pdo_dblib
fi

if [[ -z "${EXTENSIONS##*,pdo_oci,*}" ]]; then
    record_log info "---------- Install pdo_oci ----------"
	docker-php-ext-install ${MC} pdo_oci
fi

if [[ -z "${EXTENSIONS##*,pdo_odbc,*}" ]]; then
    record_log info "---------- Install pdo_odbc ----------"
	docker-php-ext-install ${MC} pdo_odbc
fi

if [[ -z "${EXTENSIONS##*,pdo_pgsql,*}" ]]; then
    record_log info "---------- Install pdo_pgsql ----------"
    apk --no-cache add postgresql-dev \
    && docker-php-ext-install ${MC} pdo_pgsql
fi

if [[ -z "${EXTENSIONS##*,pgsql,*}" ]]; then
    record_log info "---------- Install pgsql ----------"
    apk --no-cache add postgresql-dev \
    && docker-php-ext-install ${MC} pgsql
fi

if [[ -z "${EXTENSIONS##*,oci8,*}" ]]; then
    record_log info "---------- Install oci8 ----------"
	docker-php-ext-install ${MC} oci8
fi

if [[ -z "${EXTENSIONS##*,odbc,*}" ]]; then
    record_log info "---------- Install odbc ----------"
	docker-php-ext-install ${MC} odbc
fi

if [[ -z "${EXTENSIONS##*,dba,*}" ]]; then
    record_log info "---------- Install dba ----------"
	docker-php-ext-install ${MC} dba
fi

if [[ -z "${EXTENSIONS##*,gd,*}" ]]; then
    echo "---------- Install gd ----------"
    isPhpVersionGreaterOrEqual 7 4

    if [[ "$?" = "1" ]]; then
        # "--with-xxx-dir" was removed from php 7.4,
        # issue: https://github.com/docker-library/php/issues/912
        options="--with-freetype --with-jpeg"
    else
        options="--with-gd --with-freetype-dir=/usr/include/ --with-png-dir=/usr/include/ --with-jpeg-dir=/usr/include/"
    fi

    apk add --no-cache \
        freetype \
        freetype-dev \
        libpng \
        libpng-dev \
        libjpeg-turbo \
        libjpeg-turbo-dev \
    && docker-php-ext-configure gd ${options} \
    && docker-php-ext-install ${MC} gd \
    && apk del \
        freetype-dev \
        libpng-dev \
        libjpeg-turbo-dev
fi

if [[ -z "${EXTENSIONS##*,intl,*}" ]]; then
    record_log info "---------- Install intl ----------"
    apk add --no-cache icu-dev
    docker-php-ext-install ${MC} intl
fi

if [[ -z "${EXTENSIONS##*,bz2,*}" ]]; then
    record_log info "---------- Install bz2 ----------"
    apk add --no-cache bzip2-dev
    docker-php-ext-install ${MC} bz2
fi

if [[ -z "${EXTENSIONS##*,soap,*}" ]]; then
    record_log info "---------- Install soap ----------"
    apk add --no-cache libxml2-dev
	docker-php-ext-install ${MC} soap
fi

if [[ -z "${EXTENSIONS##*,xsl,*}" ]]; then
    record_log info "---------- Install xsl ----------"
	apk add --no-cache libxml2-dev libxslt-dev
	docker-php-ext-install ${MC} xsl
fi

if [[ -z "${EXTENSIONS##*,xmlrpc,*}" ]]; then
    record_log info "---------- Install xmlrpc ----------"
	apk add --no-cache libxml2-dev libxslt-dev
	docker-php-ext-install ${MC} xmlrpc
fi

if [[ -z "${EXTENSIONS##*,wddx,*}" ]]; then
    record_log info "---------- Install wddx ----------"
	apk add --no-cache libxml2-dev libxslt-dev
	docker-php-ext-install ${MC} wddx
fi

if [[ -z "${EXTENSIONS##*,readline,*}" ]]; then
    record_log info "---------- Install readline ----------"
	apk add --no-cache readline-dev
	apk add --no-cache libedit-dev
	docker-php-ext-install ${MC} readline
fi

if [[ -z "${EXTENSIONS##*,snmp,*}" ]]; then
    record_log info "---------- Install snmp ----------"
	apk add --no-cache net-snmp-dev
	docker-php-ext-install ${MC} snmp
fi

if [[ -z "${EXTENSIONS##*,pspell,*}" ]]; then
    record_log info "---------- Install pspell ----------"
	apk add --no-cache aspell-dev
	apk add --no-cache aspell-en
	docker-php-ext-install ${MC} pspell
fi

if [[ -z "${EXTENSIONS##*,recode,*}" ]]; then
    record_log info "---------- Install recode ----------"
	apk add --no-cache recode-dev
	docker-php-ext-install ${MC} recode
fi

if [[ -z "${EXTENSIONS##*,gmp,*}" ]]; then
    record_log info "---------- Install gmp ----------"
	apk add --no-cache gmp-dev
	docker-php-ext-install ${MC} gmp
fi

if [[ -z "${EXTENSIONS##*,imap,*}" ]]; then
    record_log info "---------- Install imap ----------"
	apk add --no-cache imap-dev
    docker-php-ext-configure imap --with-imap --with-imap-ssl
	docker-php-ext-install ${MC} imap
fi

if [[ -z "${EXTENSIONS##*,ldap,*}" ]]; then
    record_log info "---------- Install ldap ----------"
	apk add --no-cache ldb-dev
	apk add --no-cache openldap-dev
	docker-php-ext-install ${MC} ldap
fi

if [[ -z "${EXTENSIONS##*,imagick,*}" ]]; then
    record_log info "---------- Install imagick ----------"
	apk add --no-cache file-dev
	apk add --no-cache imagemagick-dev
    printf "\n" | pecl install imagick-3.4.4
    docker-php-ext-enable imagick
fi

if [[ -z "${EXTENSIONS##*,rar,*}" ]]; then
    record_log info "---------- Install rar ----------"
    printf "\n" | pecl install rar
    docker-php-ext-enable rar
fi

if [[ -z "${EXTENSIONS##*,ast,*}" ]]; then
    record_log info "---------- Install ast ----------"
    printf "\n" | pecl install ast
    docker-php-ext-enable ast
fi

if [[ -z "${EXTENSIONS##*,msgpack,*}" ]]; then
    record_log info "---------- Install msgpack ----------"
    printf "\n" | pecl install msgpack
    docker-php-ext-enable msgpack
fi

if [[ -z "${EXTENSIONS##*,amqp,*}" ]]; then
    record_log info "---------- Install amqp ----------"
    apk add --no-cache rabbitmq-c-dev
    installExtensionFromTgz amqp-1.9.4
fi

if [[ -z "${EXTENSIONS##*,redis,*}" ]]; then
    record_log info "---------- Install redis ----------"
    installExtensionFromTgz redis-5.1.1
fi

if [[ -z "${EXTENSIONS##*,apcu,*}" ]]; then
    record_log info "---------- Install apcu ----------"
    installExtensionFromTgz apcu-5.1.18
fi

if [[ -z "${EXTENSIONS##*,xdebug,*}" ]]; then
    record_log info "---------- Install xdebug ----------"
    installExtensionFromTgz xdebug-2.9.1
fi

if [[ -z "${EXTENSIONS##*,event,*}" ]]; then
    record_log info "---------- Install event ----------"
    apk add --no-cache libevent-dev
    export is_sockets_installed=$(php -r "echo extension_loaded('sockets');")

    if [[ "${is_sockets_installed}" = "" ]]; then
        record_log info "---------- event is depend on sockets, install sockets first ----------"
        docker-php-ext-install sockets
    fi

    record_log info "---------- Install event again ----------"
    installExtensionFromTgz event-2.5.3  "--ini-name event.ini"
fi

if [[ -z "${EXTENSIONS##*,mongodb,*}" ]]; then
    record_log info "---------- Install mongodb ----------"
    installExtensionFromTgz mongodb-1.6.1
fi

if [[ -z "${EXTENSIONS##*,swoole,*}" ]]; then
    record_log info "---------- Install swoole ----------"
    installExtensionFromTgz swoole-4.4.15
fi

if [[ -z "${EXTENSIONS##*,zip,*}" ]]; then
    record_log info "---------- Install zip ----------"
    # Fix: https://github.com/docker-library/php/issues/797
    apk add --no-cache libzip-dev
    # docker-php-ext-configure zip --with-libzip=/usr/include

	docker-php-ext-install ${MC} zip
fi

if [ "${PHP_EXTENSIONS}" != "" ]; then
    apk del .build-deps \
    && docker-php-source delete
fi
