#!/bin/bash

function install_twine {
    python --version
    python -m pip install twine
}

function upload_to_pypi {
    local wheelhouse=$(abspath ${WHEEL_SDIR:-wheelhouse})

    install_twine

    local OS_ID=manylinux
    if [ -n "$IS_OSX" ]; then OS_ID=macosx; fi

    TWINE_USERNAME=__token__ TWINE_PASSWORD=${PYPI_KEY} twine upload ${wheelhouse}/*-${OS_ID}*.whl
}