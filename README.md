luacov-html
===========

luacov-html is a Reporter for LuaCov that generates HTML files to visualize the code coverage.

This is based on the html reporter from [luacov-multiple](https://github.com/to-kr/luacov-multiple).


Example
-------

Have a look at `example/tests/.luacov` for a fully configured example. </br>
You can view a live version of the example coverage report [here](https://wesen1.github.io/luacov-html/example-coverage-report/).


Usage
-----

Add this config to your luacov config file:

```lua
  reporter = "html",

  html = {}
```


### Config Options

The config is read from the "html" field in the luacov config.
The available options are:

| Config Option Name | Type   | Description                                                 | Default Value |
|--------------------|--------|-------------------------------------------------------------|---------------|
| outputDirectory    | string | Path to the directory to write the output to                | "luacov-html" |
| projectName        | string | Name of the project (Will be the shown root directory name) | "All Files"   |
