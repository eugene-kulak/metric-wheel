#!/bin/bash

# Define custom utilities
# Test for macOS with [ -n "$IS_OSX" ]

function install_dependencies_osx {
    #brew install cmake
    brew install boost
    brew install openblas
    brew install libpqxx
}

function install_dependencies_linux {
    yum install -y cmake3
    export CMAKE_EXE=cmake3
    yum install -y devtoolset-9
    scl enable devtoolset-9 bash
    yum install -y boost-devel
    yum install -y openblas-devel
}

function pre_build {
    if [ -n "$IS_OSX" ]; then
        install_dependencies_osx
    else
        install_dependencies_linux
    fi
}

function run_tests {
    # Runs tests on installed distribution from an empty directory
    echo "SKIP... TODO"
#    python --version
#    python -c 'import sys; import yourpackage; sys.exit(yourpackage.test())'
}

function build_wheel_cmd {
    # Builds wheel with named command, puts into $WHEEL_SDIR
    #
    # Parameters:
    #     cmd  (optional, default "pip_wheel_cmd"
    #        Name of command for building wheel
    #     repo_dir  (optional, default $REPO_DIR)
    #
    # Depends on
    #     REPO_DIR  (or via input argument)
    #     WHEEL_SDIR  (optional, default "wheelhouse")
    #     BUILD_DEPENDS (optional, default "")
    #     MANYLINUX_URL (optional, default "") (via pip_opts function)
    local cmd=${1:-pip_wheel_cmd}
    local repo_dir=${2:-$REPO_DIR}
    [ -z "$repo_dir" ] && echo "repo_dir not defined" && exit 1
    local wheelhouse=$(abspath ${WHEEL_SDIR:-wheelhouse})
    start_spinner
    if [ -n "$(is_function "pre_build")" ]; then pre_build; fi
    stop_spinner
    if [ -n "$BUILD_DEPENDS" ]; then
        pip install $(pip_opts) $BUILD_DEPENDS
    fi
    export METRIC_SOURCE_PATH=`python2 -c "import os,sys; print os.path.realpath(os.path.join(sys.argv[1], os.pardir))" ${repo_dir}`
    export MAKE="make -j2"
    (cd $repo_dir && $cmd $wheelhouse)
    repair_wheelhouse $wheelhouse
}
