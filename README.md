# Publish Anaconda Package
A Github Action to publish your Python package to Anaconda repository.
This one is modified to be compatible with intbio python package example workflow https://github.com/intbio/pypkg_example

### Example workflow
```yaml
name: Publish_to_conda

on: [release]

jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    - name: publish-to-conda
      uses: intbio/conda-package-publish-action@master
      env:
        ANACONDA_USERNAME: ${{ secrets.ANACONDA_USERNAME }}
        ANACONDA_PASSWORD: ${{ secrets.ANACONDA_PASSWORD }}        
```
