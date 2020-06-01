#!/bin/bash

# Run the tests
if ! lua test-suite.lua; then
  exit 1
fi

# Print the coverage summary
echo ""
sed -ne "/File.*Hits.*Missed.*Coverage/,$ p" luacov.report.out
exit 0
