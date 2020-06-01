---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local TestCase = require "wLuaUnit.TestCase"

---
-- Checks that the TemplateData.Line class works as expected.
--
-- @type TestLine
--
local TestLine = TestCase:extend()


---
-- The require path for the class that is tested by this TestCase
--
-- @tfield string testClassPath
--
TestLine.testClassPath = "luacov.html.Writer.TemplateData.Line"


-- Public Methods

---
-- Checks that the line can be returned as expected.
--
function TestLine:testCanReturnLine()

  local Line = self.testClass

  local lineCoverageDataMock = self:getMock("luacov.html.CoverageData.Line", "LineCoverageDataMock")

  -- Case A: Line without leading and trailing whitespace
  local lineA = Line(lineCoverageDataMock)
  local outputLineA
  lineCoverageDataMock.getLine
                      :should_be_called()
                      :and_will_return("function run(_verbose)")
                      :when(
                        function()
                          outputLineA = lineA:getLine()
                        end
                      )

  self:assertEquals(outputLineA, "function run(_verbose)")


  -- Case B: Line with leading and without trailing whitespace
  local lineB = Line(lineCoverageDataMock)
  local outputLineB
  lineCoverageDataMock.getLine
                      :should_be_called()
                      :and_will_return("  print(\"hello\")")
                      :when(
                        function()
                          outputLineB = lineB:getLine()
                        end
                      )

  self:assertEquals(outputLineB, "  print(\"hello\")", "Should not have removed the leading whitespace")


  -- Case C: Line without leading and with trailing whitespace
  local lineC = Line(lineCoverageDataMock)
  local outputLineC
  lineCoverageDataMock.getLine
                      :should_be_called()
                      :and_will_return("os.exit(1)   ")
                      :when(
                        function()
                          outputLineC = lineC:getLine()
                        end
                      )

  self:assertEquals(outputLineC, "os.exit(1)", "Should have removed the trailing whitespace")


  -- Case D: Line with leading and trailing whitespace
  local lineD = Line(lineCoverageDataMock)
  local outputLineD
  lineCoverageDataMock.getLine
                      :should_be_called()
                      :and_will_return("   return 2   ")
                      :when(
                        function()
                          outputLineD = lineD:getLine()
                        end
                      )

  self:assertEquals(outputLineD, "   return 2", "Should have kept the leading whitespace and removed the trailing whitespace")


  -- Case E: Line that contains only whitespace
  local lineE = Line(lineCoverageDataMock)
  local outputLineE
  lineCoverageDataMock.getLine
                      :should_be_called()
                      :and_will_return("     ")
                      :when(
                        function()
                          outputLineE = lineE:getLine()
                        end
                      )

  self:assertEquals(outputLineE, "\n", "Should have replaced the whitespace only line by a line break")


  -- Case F: Line that contains only whitespace like characters
  local lineF = Line(lineCoverageDataMock)
  local outputLineF
  lineCoverageDataMock.getLine
                      :should_be_called()
                      :and_will_return("  \t  \t")
                      :when(
                        function()
                          outputLineF = lineF:getLine()
                        end
                      )

  self:assertEquals(outputLineF, "\n", "Should have replaced the whitespace like line by a line break")


  -- Case G: Line that is completely empty
  local lineG = Line(lineCoverageDataMock)
  local outputLineG
  lineCoverageDataMock.getLine
                      :should_be_called()
                      :and_will_return("")
                      :when(
                        function()
                          outputLineG = lineG:getLine()
                        end
                      )

  self:assertEquals(outputLineG, "\n", "Should have replaced the empty line by a line break")

end

---
-- Checks that the line number can be returned as expected.
--
function TestLine:testCanReturnLineNumber()

  local Line = self.testClass

  local lineCoverageDataMock = self:getMock("luacov.html.CoverageData.Line", "LineCoverageDataMock")

  local line = Line(lineCoverageDataMock)
  local lineNumber
  lineCoverageDataMock.getLineNumber
                      :should_be_called()
                      :and_will_return(37)
                      :when(
                        function()
                          lineNumber = line:getLineNumber()
                        end
                      )

  self:assertEquals(lineNumber, 37)

end

---
-- Checks that the number of hits text can be generated as expected.
--
function TestLine:testCanReturnNumberOfHitsText()

  local Line = self.testClass

  local lineCoverageDataMock = self:getMock("luacov.html.CoverageData.Line", "LineCoverageDataMock")

  -- Case A: Number of hits > 0
  local lineA = Line(lineCoverageDataMock)
  local numberOfHitsTextA
  lineCoverageDataMock.getNumberOfHits
                      :should_be_called()
                      :and_will_return(6)
                      :when(
                        function()
                          numberOfHitsTextA = lineA:getNumberOfHitsText()
                        end
                      )

  self:assertEquals(numberOfHitsTextA, "6x")


  -- Case B: Another number of hits > 0
  local lineB = Line(lineCoverageDataMock)
  local numberOfHitsTextB
  lineCoverageDataMock.getNumberOfHits
                      :should_be_called()
                      :and_will_return(41)
                      :when(
                        function()
                          numberOfHitsTextB = lineB:getNumberOfHitsText()
                        end
                      )

  self:assertEquals(numberOfHitsTextB, "41x")


  -- Case C: Number of hits = 0
  local lineC = Line(lineCoverageDataMock)
  local numberOfHitsTextC
  lineCoverageDataMock.getNumberOfHits
                      :should_be_called()
                      :and_will_return(0)
                      :when(
                        function()
                          numberOfHitsTextC = lineC:getNumberOfHitsText()
                        end
                      )

  self:assertEquals(numberOfHitsTextC, "\n")

end

---
-- Checks that the coverage type name can be returned as expected.
--
function TestLine:testCanReturnCoverageTypeName()

  local Line = self.testClass
  local LineCoverageData = require "luacov.html.CoverageData.Line"

  local lineCoverageDataMock = self:getMock("luacov.html.CoverageData.Line", "LineCoverageDataMock")

  -- Case A: TYPE_EMPTY
  local lineA = Line(lineCoverageDataMock)
  local coverageTypeNameA
  lineCoverageDataMock.getType
                      :should_be_called()
                      :and_will_return(LineCoverageData.TYPE_EMPTY)
                      :when(
                        function()
                          coverageTypeNameA = lineA:getCoverageTypeName()
                        end
                      )

  self:assertEquals(coverageTypeNameA, "empty")


  -- Case B: TYPE_MISS
  local lineB = Line(lineCoverageDataMock)
  local coverageTypeNameB
  lineCoverageDataMock.getType
                      :should_be_called()
                      :and_will_return(LineCoverageData.TYPE_MISS)
                      :when(
                        function()
                          coverageTypeNameB = lineB:getCoverageTypeName()
                        end
                      )

  self:assertEquals(coverageTypeNameB, "miss")


  -- Case C: TYPE_HIT
  local lineC = Line(lineCoverageDataMock)
  local coverageTypeNameC
  lineCoverageDataMock.getType
                      :should_be_called()
                      :and_will_return(LineCoverageData.TYPE_HIT)
                      :when(
                        function()
                          coverageTypeNameC = lineC:getCoverageTypeName()
                        end
                      )

  self:assertEquals(coverageTypeNameC, "hit")

end


---
-- Checks that the template values can be generated as expected.
--
function TestLine:testCanBeConvertedToTemplateValues()

  local Line = self.testClass
  local LineCoverageData = require "luacov.html.CoverageData.Line"

  local lineCoverageDataMock = self:getMock("luacov.html.CoverageData.Line", "LineCoverageDataMock")

  local line = Line(lineCoverageDataMock)
  local templateValues
  lineCoverageDataMock.getLine
                      :should_be_called()
                      :and_will_return("  return math.huge ^ math.huge  ")
                      :and_also(
                        lineCoverageDataMock.getLineNumber
                                            :should_be_called()
                                            :and_will_return(579)
                      )
                      :and_also(
                        lineCoverageDataMock.getNumberOfHits
                                            :should_be_called()
                                            :and_will_return(3)
                      )
                      :and_also(
                        lineCoverageDataMock.getType
                                            :should_be_called()
                                            :and_will_return(LineCoverageData.TYPE_HIT)
                      )
                      :when(
                        function()
                          templateValues = line:toTemplateValues()
                        end
                           )

  local expectedTemplateValues = {
    line = "  return math.huge ^ math.huge",
    lineNumber = 579,
    numberOfHitsText = "3x",
    coverageType = "hit"
  }

  self:assertEquals(templateValues, expectedTemplateValues)

end


return TestLine
