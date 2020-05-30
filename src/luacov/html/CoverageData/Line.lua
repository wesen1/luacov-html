---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"

---
-- Contains the coverage information about a single line.
--
-- @type Line
--
local Line = Object:extend()


-- The available Line coverage types
Line.TYPE_EMPTY = "empty"
Line.TYPE_MISS = "miss"
Line.TYPE_HIT = "hit"

---
-- The Line coverage type
--
-- @tfield string type
--
Line.type = nil

---
-- The content of the line
--
-- @tfield line line
--
Line.line = nil

---
-- The line number of the line
--
-- @tfield int lineNumber
--
Line.lineNumber = nil

---
-- The number of times the line was executed
--
-- @tfield int numberOfHits
--
Line.numberOfHits = nil


---
-- Line constructor.
--
-- @tparam string _type The Line coverage type (one of the TYPE_* constants)
-- @tparam string _line The content of the line
-- @tparam int _lineNumber The line number of the line
-- @tparam int _numberOfHits The number of times the line was executed
--
function Line:new(_type, _line, _lineNumber, _numberOfHits)

  self.type = _type
  self.line = _line
  self.lineNumber = _lineNumber

  if (self.type == Line.TYPE_EMPTY or self.type == Line.TYPE_MISS) then
    self.numberOfHits = 0
  else
    self.numberOfHits = _numberOfHits
  end

end


-- Getters and Setters

---
-- Returns the Line coverage type.
--
-- @treturn string The Line coverage type
--
function Line:getType()
  return self.type
end

---
-- Returns the content of the line.
--
-- @treturn string The content of the line
--
function Line:getLine()
  return self.line
end

---
-- Returns the line number of the line.
--
-- @treturn int The line number
--
function Line:getLineNumber()
  return self.lineNumber
end

---
-- Returns the number of times the line was executed.
--
-- @treturn int The number of times the line was executed
--
function Line:getNumberOfHits()
  return self.numberOfHits
end


return Line
