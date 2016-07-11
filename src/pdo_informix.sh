#!/usr/bin/env bash
#
# This shell scriplet is meant to be included by other shell scripts
# to set up some variables and a few helper shell functions.

function install_pdo_informix_master {
    local source_dir="$TMP/source/pdo_informix-master"
    local cwd=$(pwd)
    local revision=$1

    if [ -d "$source_dir" ] && [ -d "$source_dir/.git" ]; then
        log "pdo_informix" "Updating pdo_informix from Git Master"
        cd "$source_dir"
        git pull origin master > /dev/null
        cd "$cwd"
    else
        log "pdo_informix" "Fetching from Git Master"
        git clone https://git.php.net/repository/pecl/database/pdo_informix.git "$source_dir" > /dev/null
    fi

    if [ -n "$revision" ]; then
        log "pdo_informix" "Checkout specified revision: $revision"
        cd "$source_dir"
        git reset --hard $revision
        cd "$cwd"
    fi

    _build_pdo_informix "$source_dir"
}

function install_pdo_informix {
    local version=$1
    local package_file="PDO_INFORMIX-$version.tgz"
    local package_url="http://pecl.php.net/get/$package_file"
    local source_dir="$TMP/source/PDO_INFORMIX-$version"

    if [ -z "$version" ]; then
        echo "install_pdo_informix: No Version given." >&3
        return 1
    fi

    log "pdo_informix" "Downloading $package_url"

    # We cache the tarballs for pdo_informix versions in `packages/`.
    if [ ! -f "$TMP/packages/$package_file" ]; then
        wget -qP "$TMP/packages" "$package_url"
    fi

    # Each tarball gets extracted to `source/PDO_INFORMIX-$version`.
    if [ -d "$source_dir" ]; then
        rm -rf "$source_dir"
    fi

    tar -xzf "$TMP/packages/$package_file" -C "$TMP/source"

    [[ -f "$TMP/source/package.xml" ]] && rm "$TMP/source/package.xml"
    [[ -f "$TMP/source/package2.xml" ]] && rm "$TMP/source/package2.xml"

    _build_pdo_informix "$source_dir"
}

function _build_pdo_informix {
    local source_dir="$1"
    local cwd=$(pwd)

    if [ -z "$INFORMIXDIR" ]; then
        echo "pdo_informix: the INFORMIXDIR variable must be set to "\
            "the directory where the Informix products are installed" >&3
        return 1
    elif ! [ -d "$INFORMIXDIR" ]; then
        echo "pdo_informix: the directory defined by INFORMIXDIR does not exists " >&3
        return 1
    fi

    log "pdo_informix" "Compiling in $source_dir"

    cd "$source_dir"

    {
        $PREFIX/bin/phpize > /dev/null
        "$(pwd)/configure" --with-php-config=$PREFIX/bin/php-config > /dev/null

        make > /dev/null
        make install > /dev/null
    } >&4 2>&1

    local pdo_informix_ini="$PREFIX/etc/conf.d/pdo_informix.ini"

    local extension_dir=$("$PREFIX/bin/php" -r "echo ini_get('extension_dir');")

    if [ ! -f "$pdo_informix_ini" ]; then
        log "pdo_informix" "Installing pdo_informix configuration in $pdo_informix_ini"

        echo "extension=\"$extension_dir/pdo_informix.so\"" > $pdo_informix_ini
    fi

    log "pdo_informix" "Cleaning up."
    make clean > /dev/null

    cd "$cwd" > /dev/null
}
