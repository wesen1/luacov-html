#!/bin/bash

# Find the required paths
utilDirectoryPath="$(dirname $0)"
workingDirectory="$(pwd)"

if [[ "$utilDirectoryPath" == "/"* ]]; then
  absoluteUtilDirectoryPath=$utilDirectoryPath
else
  absoluteUtilDirectoryPath="$workingDirectory/$utilDirectoryPath"
fi

repositoryRootDirectoryPath="$absoluteUtilDirectoryPath/.."
docsDirectoryPath="$repositoryRootDirectoryPath/docs"
exampleTestDirectoryPath="$repositoryRootDirectoryPath/example/tests"


# Generate the LDoc documentation
cd "$repositoryRootDirectoryPath"
ldoc .


# Generate the example coverage report

# Install luacov-html from the source code that is stored in the repository
cd "$repositoryRootDirectoryPath"
sudo luarocks make

# Delete the already exitsing coverage-report
if [ -d "$exampleTestDirectoryPath/coverage-report" ]; then
  rm -r "$exampleTestDirectoryPath/coverage-report"
fi

# Delete the docs example coverage-report
if [ -d "$docsDirectoryPath/example-coverage-report" ]; then
  rm -r "$docsDirectoryPath/example-coverage-report"
fi

# Generate the example coverage-report and move it to the docs directory
cd "$exampleTestDirectoryPath"
lua test-suite.lua
mv "coverage-report" "example-coverage-report"
mv "example-coverage-report" "$docsDirectoryPath"


# Go back to the original working directory
cd "$workingDirectory"
