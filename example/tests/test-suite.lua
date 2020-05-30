
local TestRunner = require "wLuaUnit.TestRunner"

package.path = package.path .. ";../src/?.lua"

local runner = TestRunner()

runner:addTestDirectory("example")
      :enableCoverageAnalysis()
      :run()
