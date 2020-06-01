---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local TestCase = require "wLuaUnit.TestCase"

---
-- Checks that the HitMissStatistics class works as expected.
--
-- @type TestHitMissStatistics
--
local TestHitMissStatistics = TestCase:extend()


---
-- The require path for the class that is tested by this TestCase
--
-- @tfield string testClassPath
--
TestHitMissStatistics.testClassPath = "luacov.html.CoverageData.Util.HitMissStatistics"


-- Public Methods

---
-- Checks that numbers of hits and numbers of misses can be added as expected.
--
function TestHitMissStatistics:testCanAddNumbersOfHitsAndMisses()

  local HitMissStatistics = self.testClass

  local hitMissStatistics = HitMissStatistics()
  self:assertEquals(hitMissStatistics:getNumberOfHits(), 0)
  self:assertEquals(hitMissStatistics:getNumberOfMisses(), 0)

  hitMissStatistics:addNumberOfHits(5)
  self:assertEquals(hitMissStatistics:getNumberOfHits(), 5)
  self:assertEquals(hitMissStatistics:getNumberOfMisses(), 0)

  hitMissStatistics:addNumberOfMisses(20)
  self:assertEquals(hitMissStatistics:getNumberOfHits(), 5)
  self:assertEquals(hitMissStatistics:getNumberOfMisses(), 20)

end

---
-- Checks that the hit percentage can be calculated as expected.
--
function TestHitMissStatistics:testCanCalculateHitPercentage()

  local HitMissStatistics = self.testClass

  local hitMissStatistics = HitMissStatistics()

  -- Special case: 0 hits and 0 misses should cause a 0% hit percentage
  self:assertEquals(hitMissStatistics:calculateHitPercentage(), 0)

  hitMissStatistics:addNumberOfHits(5)
  self:assertEquals(hitMissStatistics:calculateHitPercentage(), 100)

  hitMissStatistics:addNumberOfHits(15)
  self:assertEquals(hitMissStatistics:calculateHitPercentage(), 100)

  hitMissStatistics:addNumberOfMisses(5)
  self:assertEquals(hitMissStatistics:calculateHitPercentage(), 80)

  hitMissStatistics:addNumberOfMisses(15)
  self:assertEquals(hitMissStatistics:calculateHitPercentage(), 50)

end


return TestHitMissStatistics
