---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local LineCoverageData = require "luacov.html.CoverageData.Line"
local Object = require "classic"
local stringx = require "pl.stringx"

---
-- Provides the template data for Line coverage data objects.
--
-- @type Line
--
local Line = Object:extend()


---
-- The raw Line coverage data
--
-- @tfield CoverageData.Line lineCoverageData
--
Line.lineCoverageData = nil


---
-- Line constructor.
--
-- @tparam CoverageData.Line _lineCoverageData The raw line coverage data
--
function Line:new(_lineCoverageData)
  self.lineCoverageData = _lineCoverageData
end


-- Public Methods

---
-- Generates and returns a regular table that contains all template values that are required to
-- visualize the raw Line coverage data.
--
-- @treturn table The template values
--
function Line:toTemplateValues()

  return {
    line = self:getLine(),
    lineNumber = self:getLineNumber(),
    numberOfHitsText = self:getNumberOfHitsText(),
    coverageType = self:getCoverageTypeName()
  }

end


---
-- Returns the line contents.
--
-- @treturn string The line contents
--
function Line:getLine()

  local line = stringx.rstrip(self.lineCoverageData:getLine())
  if (line == "") then
    line = "\n"
  end

  return line

end

---
-- Returns the line number.
--
-- @treturn int The line number
--
function Line:getLineNumber()
  return self.lineCoverageData:getLineNumber()
end

---
-- Returns the text that should be used to visualize the number of hits.
--
-- @treturn string The "number of hits" text
--
function Line:getNumberOfHitsText()

  local numberOfHits = self.lineCoverageData:getNumberOfHits()
  if (numberOfHits > 0) then
    return numberOfHits .. "x"
  else
    return "\n"
  end

end

---
-- Returns the line's coverage type name.
--
-- @treturn string The line's coverage type name
--
function Line:getCoverageTypeName()

  if (self.lineCoverageData:getType() == LineCoverageData.TYPE_EMPTY) then
    return "empty"
  elseif (self.lineCoverageData:getType() == LineCoverageData.TYPE_MISS) then
    return "miss"
  elseif (self.lineCoverageData:getType() == LineCoverageData.TYPE_HIT) then
    return "hit"
  end

end


return Line
