#!/bin/bash

function upload_to_pypi {
    local pypi_server=${1:-$PYPI_SERVER}
    local wheelhouse=$(abspath ${WHEEL_SDIR:-wheelhouse})
    TWINE_USERNAME=__token__ TWINE_PASSWORD=${PYPI_KEY} twine upload --repository-url ${pypi_server} ${wheelhouse}/*-manylinux*.whl
}