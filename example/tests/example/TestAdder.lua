
local TestCase = require "wLuaUnit.TestCase"

local TestAdder = TestCase:extend()


TestAdder.testClassPath = "example.Adder"


function TestAdder:testCanAddTwoNumbers()

  local Adder = self.testClass

  local adder = Adder()
  self:assertEquals(adder:add(2, 2), 4)
  self:assertEquals(adder:add(2, 0), 2)
  self:assertEquals(adder:add(1, 4), 5)

end

function TestAdder:testCanAddThreeNumbers()

  local Adder = self.testClass

  local adder = Adder()
  self:assertEquals(adder:add(3, 3, 4), 10)
  self:assertEquals(adder:add(4, -1, 0), 3)
  self:assertEquals(adder:add(50, 25, 25), 100)

end


return TestAdder
