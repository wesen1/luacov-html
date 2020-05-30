#!/bin/bash

sudo apt-get update

sudo apt-get install -y luarocks

# Install the dependencies
luarocks install classic
luarocks install penlight
luarocks install luacov
luarocks install lua-resty-template

# Install the test framework dependencies
luarocks install wluaunit

# Install LDoc
luarocks install ldoc

# Install luacheck
luarocks install luacheck
