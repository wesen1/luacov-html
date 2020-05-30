---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local TestCase = require "wLuaUnit.TestCase"

---
-- Checks that the CoverageData.Line clas works as expected.
--
-- @type TestLine
--
local TestLine = TestCase:extend()


---
-- The require path for the class that is tested by this TestCase
--
-- @tfield string testClassPath
--
TestLine.testClassPath = "luacov.html.CoverageData.Line"


-- Public Methods

---
-- Checks that the CoverageData.Line can store the coverage data for an empty/unhittable line as expected.
--
function TestLine:testCanStoreEmptyLine()

  local Line = self.testClass

  local lineWithoutNumberOfHits = Line(Line.TYPE_EMPTY, "", 5)
  self:assertEquals(lineWithoutNumberOfHits:getType(), Line.TYPE_EMPTY)
  self:assertEquals(lineWithoutNumberOfHits:getLine(), "")
  self:assertEquals(lineWithoutNumberOfHits:getLineNumber(), 5)
  self:assertEquals(lineWithoutNumberOfHits:getNumberOfHits(), 0)

  local lineWithNumberOfHits = Line(Line.TYPE_EMPTY, "  ", 7, 8)
  self:assertEquals(lineWithNumberOfHits:getType(), Line.TYPE_EMPTY)
  self:assertEquals(lineWithNumberOfHits:getLine(), "  ")
  self:assertEquals(lineWithNumberOfHits:getLineNumber(), 7)
  self:assertEquals(lineWithNumberOfHits:getNumberOfHits(), 0, "Should ignore the number of hits")

end

---
-- Checks that the CoverageData.Line can store the coverage data for a missed line as expected.
--
function TestLine:testCanStoreMissedLine()

  local Line = self.testClass

  local lineWithoutNumberOfHits = Line(Line.TYPE_MISS, "  os.exit(-1)", 200)
  self:assertEquals(lineWithoutNumberOfHits:getType(), Line.TYPE_MISS)
  self:assertEquals(lineWithoutNumberOfHits:getLine(), "  os.exit(-1)")
  self:assertEquals(lineWithoutNumberOfHits:getLineNumber(), 200)
  self:assertEquals(lineWithoutNumberOfHits:getNumberOfHits(), 0)

  local lineWithNumberOfHits = Line(Line.TYPE_MISS, "    print(myTable)", 130, 12)
  self:assertEquals(lineWithNumberOfHits:getType(), Line.TYPE_MISS)
  self:assertEquals(lineWithNumberOfHits:getLine(), "    print(myTable)")
  self:assertEquals(lineWithNumberOfHits:getLineNumber(), 130)
  self:assertEquals(lineWithNumberOfHits:getNumberOfHits(), 0, "Should ignore the number of hits")

end

---
-- Checks that the CoverageData.Line can store the coverage data for a hit line as expected.
--
function TestLine:testCanStoreHitLine()

  local Line = self.testClass

  local lineA = Line(Line.TYPE_HIT, "  result = valueA + valueB", 78, 1)
  self:assertEquals(lineA:getType(), Line.TYPE_HIT)
  self:assertEquals(lineA:getLine(), "  result = valueA + valueB")
  self:assertEquals(lineA:getLineNumber(), 78)
  self:assertEquals(lineA:getNumberOfHits(), 1, "Should not ignore the number of hits")

  local lineB = Line(Line.TYPE_HIT, "    return (checkValue > 5)", 44, 8)
  self:assertEquals(lineB:getType(), Line.TYPE_HIT)
  self:assertEquals(lineB:getLine(), "    return (checkValue > 5)")
  self:assertEquals(lineB:getLineNumber(), 44)
  self:assertEquals(lineB:getNumberOfHits(), 8, "Should not ignore the number of hits")

end

---
-- Checks that the CoverageData.Line does not modify the given raw line.
--
function TestLine:testDoesNotModifyLineContents()

  local Line = self.testClass

  local lineWithLeadingWhitespace = Line(Line.TYPE_HIT, "  a = 1", 21, 3)
  self:assertEquals(lineWithLeadingWhitespace:getType(), Line.TYPE_HIT)
  self:assertEquals(lineWithLeadingWhitespace:getLine(), "  a = 1", "Should not have removed the leading whitespace")
  self:assertEquals(lineWithLeadingWhitespace:getLineNumber(), 21)
  self:assertEquals(lineWithLeadingWhitespace:getNumberOfHits(), 3)

  local lineWithTrailingWhitespace = Line(Line.TYPE_HIT, "b = 2   ", 452, 8)
  self:assertEquals(lineWithTrailingWhitespace:getType(), Line.TYPE_HIT)
  self:assertEquals(lineWithTrailingWhitespace:getLine(), "b = 2   ", "Should not have removed the trailing whitespace")
  self:assertEquals(lineWithTrailingWhitespace:getLineNumber(), 452)
  self:assertEquals(lineWithTrailingWhitespace:getNumberOfHits(), 8)

end


return TestLine
