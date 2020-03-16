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
    mkdir output
    anaconda login --username "$ANACONDA_USERNAME" --password "$ANACONDA_PASSWORD" 
    conda build -c conda-forge -c bioconda -c intbio conda-recipe --output-folder output
    PKG=`find output -name '*.tar.bz2'`
    conda convert --platform all $PKG -o output/
    find output -name '*.tar.bz2' -exec anaconda upload --force {} \;
    anaconda logout
}

#go_to_build_dir
check_if_setup_file_exists
check_if_meta_yaml_file_exists
upload_package
