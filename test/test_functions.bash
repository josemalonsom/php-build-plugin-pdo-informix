remove_dir_if_exists() {

    local DIRNAME="$1"

    if [ -d "$DIRNAME" ]; then

        rm -rf "$DIRNAME"
    fi
}

create_configure_options() {

    local CONFIGURE_FILE="${PHP_BUILD_BASE_DIR}/default_configure_options"
    local CONFIGURE_FILE_ORIG="${CONFIGURE_FILE}.orig"

    if [ -e "$CONFIGURE_FILE_ORIG" ]; then

        return
    fi

    cp "$CONFIGURE_FILE" "$CONFIGURE_FILE_ORIG"

    {
        echo "--without-pear"
        echo "--disable-debug"

    } > "$CONFIGURE_FILE"
}

create_definition() {

    local PHP_VERSION="$1"
    local PDO_INFORMIX_VERSION="$2"

    local PHP_BUILD_DEFINITIONS_DIR="${PHP_BUILD_BASE_DIR}/definitions/"
    local DEFINITION_FILE="${PHP_BUILD_DEFINITIONS_DIR}/${PHP_VERSION}"
    local DEFINITION_FILE_ORIG="${DEFINITION_FILE}.orig"

    if [ ! -e "${DEFINITION_FILE_ORIG}" ]; then

        cp "$DEFINITION_FILE" "$DEFINITION_FILE_ORIG"
    else

        cp "$DEFINITION_FILE_ORIG" "$DEFINITION_FILE"
    fi

    local LINE="$(get_definition_line "${PDO_INFORMIX_VERSION}")"

    sed -i "\$a $LINE" "$DEFINITION_FILE"
}

get_definition_line() {

    local PDO_INFORMIX_VERSION="$1"
    local LINE=""

    case "$PDO_INFORMIX_VERSION" in

        master)
            LINE="install_pdo_informix_master"
            ;;

        [0-9]\.[0-9]\.[0-9])
            LINE="install_pdo_informix ${PDO_INFORMIX_VERSION}"
            ;;

        *)
            LINE="install_pdo_informix_master ${PDO_INFORMIX_VERSION}"
            ;;
    esac

    echo "$LINE"
}

get_pdo_informix_extension_info() {

    ${PHP_INSTALL_DIR}/bin/php --ri pdo_informix
}

assert_pdo_informix_is_enabled() {

    local OUTPUT="$1"
    local VERSION="$2"

    [[ "$OUTPUT" =~ pdo_informix.*support.*enabled ]]
    [[ "$OUTPUT" =~ Module.*release.*${VERSION} ]]
}
