#!/usr/bin/env bats

load test_functions

setup() {

    export BASE_DIR="${BATS_TEST_DIRNAME}/working-dir"
    export PHP_INSTALL_DIR="${BASE_DIR}/php"
    export PHP_BUILD_BASE_DIR="${BASE_DIR}/share/php-build"
    export PHP_BUILD_CMD="${BASE_DIR}/bin/php-build"
    export PHP_VERSION="5.6.23"

    export TMPDIR="$BASE_DIR/tmp"
    mkdir -p "$TMPDIR"

    remove_dir_if_exists "$PHP_INSTALL_DIR"

    create_configure_options
}

@test "compiles a specific version of PDO_INFORMIX" {

    local PDO_INFORMIX_VERSION="1.3.1"

    create_definition "$PHP_VERSION" "$PDO_INFORMIX_VERSION"

    run "$PHP_BUILD_CMD" "$PHP_VERSION" "$PHP_INSTALL_DIR"

    echo "$output" > /tmp/jma.traza

    [ "$status" -eq 0 ]

    run get_pdo_informix_extension_info

    assert_pdo_informix_is_enabled "$output" "$PDO_INFORMIX_VERSION"
}

@test "compiles a specific commit of PDO_INFORMIX" {

    local PDO_INFORMIX_COMMIT="26343f2"
    local PDO_INFORMIX_VERSION="1.2.7"

    create_definition "$PHP_VERSION" "$PDO_INFORMIX_COMMIT"

    run "$PHP_BUILD_CMD" "$PHP_VERSION" "$PHP_INSTALL_DIR"

    [ "$status" -eq 0 ]

    run get_pdo_informix_extension_info

    assert_pdo_informix_is_enabled "$output" "$PDO_INFORMIX_VERSION"
}

@test "compiles PDO_INFORMIX's master branch" {

    local PDO_INFORMIX_COMMIT="master"

    create_definition "$PHP_VERSION" "$PDO_INFORMIX_COMMIT"

    run "$PHP_BUILD_CMD" "$PHP_VERSION" "$PHP_INSTALL_DIR"

    [ "$status" -eq 0 ]

    run get_pdo_informix_extension_info

    assert_pdo_informix_is_enabled "$output"
}
