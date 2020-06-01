---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local TestCase = require "wLuaUnit.TestCase"

---
-- Checks that the TemplateData.HitMissStatistics class works as expected.
--
-- @type TestHitMissStatistics
--
local TestHitMissStatistics = TestCase:extend()


---
-- The require path for the class that is tested by this TestCase
--
-- @tfield string testClassPath
--
TestHitMissStatistics.testClassPath = "luacov.html.Writer.TemplateData.HitMissStatistics"


-- Public Methods

---
-- Checks that the number of hits is returned as expected.
--
function TestHitMissStatistics:testCanReturnNumberOfHits()

  local HitMissStatistics = self.testClass

  local hitMissStatisticsCoverageDataMock = self:getMock(
    "luacov.html.CoverageData.Util.HitMissStatistics", "HitMissStatisticsCoverageDataMock"
  )

  local hitMissStatistics = HitMissStatistics(hitMissStatisticsCoverageDataMock)

  local numberOfHits
  hitMissStatisticsCoverageDataMock.getNumberOfHits
                                   :should_be_called()
                                   :and_will_return(54)
                                   :when(
                                     function()
                                       numberOfHits = hitMissStatistics:getNumberOfHits()
                                     end
                                   )

  self:assertEquals(numberOfHits, 54)

end

---
-- Checks that the number of misses is returned as expected.
--
function TestHitMissStatistics:testCanReturnNumberOfMisses()

  local HitMissStatistics = self.testClass

  local hitMissStatisticsCoverageDataMock = self:getMock(
    "luacov.html.CoverageData.Util.HitMissStatistics", "HitMissStatisticsCoverageDataMock"
  )

  local hitMissStatistics = HitMissStatistics(hitMissStatisticsCoverageDataMock)

  local numberOfMisses
  hitMissStatisticsCoverageDataMock.getNumberOfMisses
                                   :should_be_called()
                                   :and_will_return(13)
                                   :when(
                                     function()
                                       numberOfMisses = hitMissStatistics:getNumberOfMisses()
                                     end
                                   )

  self:assertEquals(numberOfMisses, 13)

end

---
-- Checks that the formatted hit percentage is generated as expected.
--
function TestHitMissStatistics:testCanReturnFormattedHitPercentage()

  local HitMissStatistics = self.testClass

  local hitMissStatisticsCoverageDataMock = self:getMock(
    "luacov.html.CoverageData.Util.HitMissStatistics", "HitMissStatisticsCoverageDataMock"
  )

  -- Case A: Percentage has more than two digits after the comma
  local hitMissStatisticsA = HitMissStatistics(hitMissStatisticsCoverageDataMock)
  local formattedHitPercentageA
  hitMissStatisticsCoverageDataMock.calculateHitPercentage
                                   :should_be_called()
                                   :and_will_return(84.12612)
                                   :when(
                                     function()
                                       formattedHitPercentageA = hitMissStatisticsA:getFormattedHitPercentage()
                                     end
                                   )

  self:assertEquals(formattedHitPercentageA, "84.13", "Should have rounded the hit percentage")


  -- Case B: Percentage has less than two digits after the comma
  local hitMissStatisticsB = HitMissStatistics(hitMissStatisticsCoverageDataMock)
  local formattedHitPercentageB
  hitMissStatisticsCoverageDataMock.calculateHitPercentage
                                   :should_be_called()
                                   :and_will_return(34)
                                   :when(
                                     function()
                                       formattedHitPercentageB = hitMissStatisticsB:getFormattedHitPercentage()
                                     end
                                   )

  self:assertEquals(formattedHitPercentageB, "34.00", "Should have added trailing zeros")

end

---
-- Checks that the hit percentage status text is generated as expected.
--
function TestHitMissStatistics:testCanReturnHitPercentageStatusText()

  local HitMissStatistics = self.testClass

  local hitMissStatisticsCoverageDataMock = self:getMock(
    "luacov.html.CoverageData.Util.HitMissStatistics", "HitMissStatisticsCoverageDataMock"
  )

  local hitMissStatistics = HitMissStatistics(hitMissStatisticsCoverageDataMock)

  local hitPercentageStatusTextZero
  local hitPercentageStatusTextFortyNinePointNine
  local hitPercentageStatusTextFifty
  local hitPercentageStatusTextFiftyPointOne
  local hitPercentageStatusTextSeventyNinePointNine
  local hitPercentageStatusTextEighty
  local hitPercentageStatusTextEightyPointOne
  local hitPercentageStatusTextOneHundred

  hitMissStatisticsCoverageDataMock.calculateHitPercentage
                                   :should_be_called()
                                   :and_will_return(0)
                                   :and_then(
                                     hitMissStatisticsCoverageDataMock.calculateHitPercentage
                                                                      :should_be_called()
                                                                      :and_will_return(49.9)
                                   )
                                   :and_then(
                                     hitMissStatisticsCoverageDataMock.calculateHitPercentage
                                                                      :should_be_called()
                                                                      :and_will_return(50.0)
                                   )
                                   :and_then(
                                     hitMissStatisticsCoverageDataMock.calculateHitPercentage
                                                                      :should_be_called()
                                                                      :and_will_return(50.1)
                                   )
                                   :and_then(
                                     hitMissStatisticsCoverageDataMock.calculateHitPercentage
                                                                      :should_be_called()
                                                                      :and_will_return(79.9)
                                   )
                                   :and_then(
                                     hitMissStatisticsCoverageDataMock.calculateHitPercentage
                                                                      :should_be_called()
                                                                      :and_will_return(80.0)
                                   )
                                   :and_then(
                                     hitMissStatisticsCoverageDataMock.calculateHitPercentage
                                                                      :should_be_called()
                                                                      :and_will_return(80.1)
                                   )
                                   :and_then(
                                     hitMissStatisticsCoverageDataMock.calculateHitPercentage
                                                                      :should_be_called()
                                                                      :and_will_return(100)
                                   )
                                   :when(
                                     function()

                                       hitPercentageStatusTextZero = hitMissStatistics:getHitPercentageStatusText()
                                       hitPercentageStatusTextFortyNinePointNine = hitMissStatistics:getHitPercentageStatusText()
                                       hitPercentageStatusTextFifty = hitMissStatistics:getHitPercentageStatusText()
                                       hitPercentageStatusTextFiftyPointOne = hitMissStatistics:getHitPercentageStatusText()
                                       hitPercentageStatusTextSeventyNinePointNine = hitMissStatistics:getHitPercentageStatusText()
                                       hitPercentageStatusTextEighty = hitMissStatistics:getHitPercentageStatusText()
                                       hitPercentageStatusTextEightyPointOne = hitMissStatistics:getHitPercentageStatusText()
                                       hitPercentageStatusTextOneHundred = hitMissStatistics:getHitPercentageStatusText()

                                     end
                                   )

  self:assertEquals(hitPercentageStatusTextZero, "low")
  self:assertEquals(hitPercentageStatusTextFortyNinePointNine, "low")
  self:assertEquals(hitPercentageStatusTextFifty, "medium")
  self:assertEquals(hitPercentageStatusTextFiftyPointOne, "medium")
  self:assertEquals(hitPercentageStatusTextSeventyNinePointNine, "medium")
  self:assertEquals(hitPercentageStatusTextEighty, "medium")
  self:assertEquals(hitPercentageStatusTextEightyPointOne, "high")
  self:assertEquals(hitPercentageStatusTextOneHundred, "high")

end


---
-- Checks that the template values can be generated as expected.
--
function TestHitMissStatistics:testCanBeConvertedToTemplateValues()

  local HitMissStatistics = self.testClass

  local hitMissStatisticsCoverageDataMock = self:getMock(
    "luacov.html.CoverageData.Util.HitMissStatistics", "HitMissStatisticsCoverageDataMock"
  )

  local hitMissStatistics = HitMissStatistics(hitMissStatisticsCoverageDataMock)

  local templateValues
  hitMissStatisticsCoverageDataMock.getNumberOfHits
                                   :should_be_called()
                                   :and_will_return(120)
                                   :and_also(
                                     hitMissStatisticsCoverageDataMock.getNumberOfMisses
                                                                      :should_be_called()
                                                                      :and_will_return(40)
                                   )
                                   :and_also(
                                     hitMissStatisticsCoverageDataMock.calculateHitPercentage
                                                                      :should_be_called()
                                                                      :multiple_times(2)
                                                                      :and_will_return(75.0)
                                   )
                                   :when(
                                     function()
                                       templateValues = hitMissStatistics:toTemplateValues()
                                     end
                                   )

  local expectedTemplateValues = {
    numberOfHits = 120,
    numberOfMisses = 40,
    formattedHitPercentage = "75.00",
    hitPercentageStatusText = "medium"
  }

  self:assertEquals(templateValues, expectedTemplateValues)

end


return TestHitMissStatistics
