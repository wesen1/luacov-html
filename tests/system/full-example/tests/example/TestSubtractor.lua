
local TestCase = require "wLuaUnit.TestCase"

local TestSubtractor = TestCase:extend()


TestSubtractor.testClassPath = "example.Subtractor"


function TestSubtractor:testCanBeInstantiated()

  local Subtractor = self.testClass

  Subtractor()

end


return TestSubtractor
