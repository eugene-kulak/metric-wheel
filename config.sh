#!/bin/bash

# Define custom utilities
# Test for macOS with [ -n "$IS_OSX" ]

function install_dependencies_osx {
    brew install openblas
    export METRIC_SOURCE_PATH=`python2 -c "import os,sys; print os.path.realpath(os.path.join(sys.argv[1], os.pardir))" ${repo_dir}`
    export MAKE="make -j2"
}

function install_dependencies_linux {
    yum install -y cmake3
    export CMAKE_EXE=cmake3
    yum install -y devtoolset-9
    scl enable devtoolset-9 bash
    yum install -y boost-devel
    yum install -y openblas-devel
    export METRIC_SOURCE_PATH=`python2 -c "import os,sys; print os.path.realpath(os.path.join(sys.argv[1], os.pardir))" ${repo_dir}`
    export MAKE="make -j2"
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
    python --version
    python -c 'import sys; import yourpackage; sys.exit(yourpackage.test())'
}
