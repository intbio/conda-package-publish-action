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
    echo $INPUT_ANACONDAUSERNAME | md5sum
    echo $INPUT_ANACONDAPASSWORD | md5sum
    export PASWRD=$INPUT_ANACONDAPASSWORD
    anaconda login --username intbiotest --password "$ANACONDA_PASSWORD"
    conda build -c conda-forge conda-recipe
    anaconda logout
}

go_to_build_dir
check_if_setup_file_exists
check_if_meta_yaml_file_exists
upload_package
