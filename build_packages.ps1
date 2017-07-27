Set-PSDebug -Trace 1
Get-ChildItem Env:

# Switch to root environment to have access to conda-build
activate root

conda install -n root conda-build=2 anaconda-client

# Don't auto-upload, instead we upload manually specifying a token
conda config --set anaconda_upload no

cd recipes

conda build --python $env:PYTHON_VERSION glue-core
$BUILD_OUTPUT = cmd /c conda build --python $env:PYTHON_VERSION glue-core --output 2>&1
echo $BUILD_OUTPUT

if ($env:APPVEYOR_PULL_REQUEST_NUMBER -eq "" -and $env:APPVEYOR_REPO_BRANCH -eq "appveyor") {
  anaconda -t $env:ANACONDA_TOKEN upload --force -l dev $BUILD_OUTPUT;
}
