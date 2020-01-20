#!/bin/bash

set -ex
set -o pipefail

go_to_build_dir() {
    echo "Input subdir is:"
    echo $INPUT_SUBDIR
    if [ ! -z $INPUT_SUBDIR ]; then
        cd $INPUT_SUBDIR
    fi
}

check_if_setup_file_exists() {
    if [ ! -f setup.py ]; then
        echo "setup.py must exist in the directory that is being packaged and published."
        exit 1
    fi
}

check_if_meta_yaml_file_exists() {
    if [ ! -f conda-recipe/meta.yaml ]; then
        echo "meta.yaml must exist in the conda-recipe directory that is being packaged and published."
        exit 1
    fi
}

upload_package(){
    conda config --set anaconda_upload yes
    echo $INPUT_ANACONDAUSERNAME
    anaconda login --username $INPUT_ANACONDAUSERNAME --password $INPUT_ANACONDAPASSWORD
    conda build -c conda-forge conda-recipe
    anaconda logout
}

go_to_build_dir
check_if_setup_file_exists
check_if_meta_yaml_file_exists
upload_package
