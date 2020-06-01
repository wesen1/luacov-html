---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local TestCase = require "wLuaUnit.TestCase"

---
-- Checks that the TemplateData.Total class works as expected.
--
-- @type TestTotal
--
local TestTotal = TestCase:extend()


---
-- The require path for the class that is tested by this TestCase
--
-- @tfield string testClassPath
--
TestTotal.testClassPath = "luacov.html.Writer.TemplateData.Total"


-- Public Methods

---
-- Checks that the formatted start timestamp can be returned as expected.
--
function TestTotal:testCanReturnFormattedStartTimestamp()

  local Total = self.testClass

  local totalCoverageDataMock = self:getMock("luacov.html.CoverageData.Total", "TotalCoverageDataMock")


  -- Example A
  local totalA = Total(totalCoverageDataMock)
  local dateA = { year = 2020, month = 5, day = 31, hour = 16, min = 7, sec = 45 }
  local formattedStartTimestampA

  totalCoverageDataMock.getStartTimestamp
                       :should_be_called()
                       :and_will_return(os.time(dateA))
                       :when(
                         function()
                           formattedStartTimestampA = totalA:getFormattedStartTimestamp()
                         end
                       )

  self:assertEquals(formattedStartTimestampA, "2020-05-31 16:07:45")


  -- Example B
  local totalB = Total(totalCoverageDataMock)
  local dateB = { year = 2018, month = 7, day = 4, hour = 13, min = 52, sec = 8 }
  local formattedStartTimestampB

  totalCoverageDataMock.getStartTimestamp
                       :should_be_called()
                       :and_will_return(os.time(dateB))
                       :when(
                         function()
                           formattedStartTimestampB = totalB:getFormattedStartTimestamp()
                         end
                       )

  self:assertEquals(formattedStartTimestampB, "2018-07-04 13:52:08")


  -- Example C
  local totalC = Total(totalCoverageDataMock)
  local dateC = { year = 2021, month = 11, day = 24, hour = 22, min = 41, sec = 59 }
  local formattedStartTimestampC

  totalCoverageDataMock.getStartTimestamp
                       :should_be_called()
                       :and_will_return(os.time(dateC))
                       :when(
                         function()
                           formattedStartTimestampC = totalC:getFormattedStartTimestamp()
                         end
                       )

  self:assertEquals(formattedStartTimestampC, "2021-11-24 22:41:59")

end


---
-- Checks that the template values can be generated as expected.
--
function TestTotal:testCanBeConvertedToTemplateValues()

  local Total = self.testClass

  local totalCoverageDataMock = self:getMock("luacov.html.CoverageData.Total", "TotalCoverageDataMock")

  local total = Total(totalCoverageDataMock)
  local date = { year = 2014, month = 3, day = 18, hour = 2, min = 51, sec = 10 }

  local templateValues
  totalCoverageDataMock.getStartTimestamp
                       :should_be_called()
                       :and_will_return(os.time(date))
                       :when(
                         function()
                           templateValues = total:toTemplateValues()
                         end
                       )

  local expectedTemplateValues = {
    startTimestamp = "2014-03-18 02:51:10"
  }

  self:assertEquals(templateValues, expectedTemplateValues)

end


return TestTotal
