
local TestRunner = require "wLuaUnit.TestRunner"

package.path = package.path .. ";../src/?.lua"
package.path = "../../../../src/?.lua;" .. package.path

local runner = TestRunner()

runner:addTestDirectory("example")
      :enableCoverageAnalysis()
      :run()
