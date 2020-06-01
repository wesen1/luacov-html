#!/bin/bash

testsDirectoryPath="$(dirname $0)"
workingDirectory="$(pwd)"

# Run the tests
cd "$testsDirectoryPath"
if ! lua test-suite.lua; then
  exit 1
fi

# Print the coverage summary
echo ""
sed -ne "/File.*Hits.*Missed.*Coverage/,$ p" luacov.report.out

# Go back to the previous working directory
cd "$workingDirectory"

exit 0
