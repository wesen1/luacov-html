
local TestCase = require "wLuaUnit.TestCase"

local TestMultiplier = TestCase:extend()


TestMultiplier.testClassPath = "example.Multiplier"


function TestMultiplier:testCanMultiplyTwoNumbers()

  local Multiplier = self.testClass

  local multiplier = Multiplier()
  self:assertEquals(multiplier:multiply(2, 7), 14)
  self:assertEquals(multiplier:multiply(0, 999), 0)
  self:assertEquals(multiplier:multiply(100, 100), 10000)

end


return TestMultiplier
