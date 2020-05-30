
local TestCase = require "wLuaUnit.TestCase"

local TestDivider = TestCase:extend()


TestDivider.testClassPath = "example.Divider"


function TestDivider:testCanBeInstantiated()

  local Divider = self.testClass

  Divider()

end


return TestDivider
