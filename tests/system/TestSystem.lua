---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"
local luaunit = require "luaunit"

---
-- Checks that the HTML reporter generates the expected output files.
--
-- @type TestSystem
--
local TestSystem = Object:extend()


-- Public Methods

---
-- Checks that an empty coverage report is generated as expected.
--
function TestSystem:testEmptyExample()

  local dir = require "pl.dir"
  local path = require "pl.path"

  -- Remove the old coverage report output
  if (path.exists("system/empty-example/luacov-html")) then
    dir.rmtree("system/empty-example/luacov-html")
  end
  luaunit.assertFalse(path.exists("system/empty-example/luacov-html"))

  -- Generate a new coverage report
  os.execute("cd system/empty-example && lua empty-example.lua 2>&1 > /dev/null")
  luaunit.assertEquals(
    path.exists("system/empty-example/luacov-html"), "system/empty-example/luacov-html"
  )

  -- Check the diff between the expected and actual result
  local compareCommand = "diff -r system/empty-example/expected-result system/empty-example/luacov-html"

  local stream = io.popen(compareCommand, "r")
  local processOutput = stream:read("*a")
  stream:close()

  local expectedFooterTimestampDiff = self:generateExpectedFooterTimestampDiff(
    "system/empty-example/expected-result/index.html",
    "system/empty-example/luacov-html/index.html",
    58
  )

  local expectedDiff = "^" .. expectedFooterTimestampDiff .. "\n$"
  luaunit.assertStrMatches(processOutput, expectedDiff)

end


---
-- Checks that a fully configured coverage report (project name and output directory)
-- with all possible coverage categories (low, medium, difficult) is generated as expected.
--
function TestSystem:testFullExample()

  local dir = require "pl.dir"
  local path = require "pl.path"

  -- Remove the old coverage report output
  if (path.exists("system/full-example/tests/coverage-report")) then
    dir.rmtree("system/full-example/tests/coverage-report")
  end
  luaunit.assertFalse(path.exists("system/full-example/tests/coverage-report"))

  -- Generate a new coverage report
  os.execute("cd system/full-example/tests && lua test-suite.lua 2>&1 > /dev/null")
  luaunit.assertEquals(
    path.exists("system/full-example/tests/coverage-report"), "system/full-example/tests/coverage-report"
  )

  -- Check the diff between the expected and actual result
  local compareCommand = "diff -r system/full-example/expected-result system/full-example/tests/coverage-report"

  local stream = io.popen(compareCommand, "r")
  local processOutput = stream:read("*a")
  stream:close()


  local expectedFooterTimestampDiffs = {
    self:generateExpectedFooterTimestampDiff(
      "system/full-example/expected-result/index.html",
      "system/full-example/tests/coverage-report/index.html",
      83
    ),
    self:generateExpectedFooterTimestampDiff(
      "system/full-example/expected-result/src/example/Adder.html",
      "system/full-example/tests/coverage-report/src/example/Adder.html",
      152
    ),
    self:generateExpectedFooterTimestampDiff(
      "system/full-example/expected-result/src/example/Divider.html",
      "system/full-example/tests/coverage-report/src/example/Divider.html",
      211
    ),
    self:generateExpectedFooterTimestampDiff(
      "system/full-example/expected-result/src/example/index.html",
      "system/full-example/tests/coverage-report/src/example/index.html",
      134
    ),
    self:generateExpectedFooterTimestampDiff(
      "system/full-example/expected-result/src/example/Multiplier.html",
      "system/full-example/tests/coverage-report/src/example/Multiplier.html",
      121
    ),
    self:generateExpectedFooterTimestampDiff(
      "system/full-example/expected-result/src/example/Subtractor.html",
      "system/full-example/tests/coverage-report/src/example/Subtractor.html",
      122
    ),
    self:generateExpectedFooterTimestampDiff(
      "system/full-example/expected-result/src/index.html",
      "system/full-example/tests/coverage-report/src/index.html",
      86
    )
  }

  local expectedDiff = "^" .. table.concat(expectedFooterTimestampDiffs, "\n") .. "\n$"
  luaunit.assertStrMatches(processOutput, expectedDiff)

end


-- Private Methods

---
-- Generates a pattern that matches the `diff -r` output for a timestamp diff in the
-- footer of an output HTML file.
--
-- @tparam string _expectedResultFilePath The file path to the expected result file in which a timestamp diff is expected
-- @tparam string _actualResultFilePath The file path to the actual result file in which a timestamp diff is expected
-- @tparam int _timestampLineNumber The line number in which the timestamp diff is expected
--
-- @treturn string The generated pattern
--
function TestSystem:generateExpectedFooterTimestampDiff(_expectedResultFilePath, _actualResultFilePath, _timestampLineNumber)

  local anyTimestampPattern = "[0-9][0-9][0-9][0-9]%-[0-1][0-9]%-[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9]"
  local footerTextStart = "Code coverage generated by <a href=\"https://keplerproject%.github%.io/luacov/\" target=\"_blank\">LuaCov</a> at "

  local expectedResultFilePathPattern = _expectedResultFilePath:gsub("%-", "%%-"):gsub("%.", "%%.")
  local actualResultFilePathPattern = _actualResultFilePath:gsub("%-", "%%-"):gsub("%.", "%%.")

  local expectedDiffLines = {
    "diff %-r " .. expectedResultFilePathPattern .. " " .. actualResultFilePathPattern,
    _timestampLineNumber .. "c" .. _timestampLineNumber,
    "<         " .. footerTextStart .. anyTimestampPattern,
    "%-%-%-",
    ">         " .. footerTextStart .. anyTimestampPattern
  }

  return table.concat(expectedDiffLines, "\n")

end


return TestSystem
