# Switch to root environment to have access to conda-build
activate root
conda install conda-build=2 anaconda-client

# Don't auto-upload, instead we upload manually specifying a token
conda config --set anaconda_upload no

cd recipes

$CONDA_BUILD = "conda build --python $env:PYTHON_VERSION"

$CONDA_BUILD glue-core
$CONDA_BUILD glue-core --output
if ($env:TRAVIS_EVENT_TYPE -eq "push" -and $env:TRAVIS_BRANCH -eq "appveyor") {
  anaconda -t $env:ANACONDA_TOKEN upload --force -l dev "$($CONDA_BUILD glue-core --output)";
}
