---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"

---
-- Contains the hit/miss statistics for a file system entry.
--
-- @type HitMissStatistics
--
local HitMissStatistics = Object:extend()


---
-- The number of hit lines
--
-- @tfield int numberOfHits
--
HitMissStatistics.numberOfHits = nil

---
-- The number of missed lines
--
-- @tfield int numberOfMisses
--
HitMissStatistics.numberOfMisses = nil


---
-- HitMissStatistics constructor.
--
function HitMissStatistics:new()
  self.numberOfHits = 0
  self.numberOfMisses = 0
end


-- Getters and Setters

---
-- Returns the number of hit lines.
--
-- @treturn int The number of hit lines
--
function HitMissStatistics:getNumberOfHits()
  return self.numberOfHits
end

---
-- Returns the number of missed lines.
--
-- @treturn int The number of missed lines
--
function HitMissStatistics:getNumberOfMisses()
  return self.numberOfMisses
end


-- Public Methods

---
-- Adds a number of hit lines to the statistics.
--
-- @tparam int _numberOfHits The number of hit lines to add
--
function HitMissStatistics:addNumberOfHits(_numberOfHits)
  self.numberOfHits = self.numberOfHits + _numberOfHits
end

---
-- Adds a number of missed lines to the statistics.
--
-- @tparam int _numberOfMisses The number of missed lines to add
--
function HitMissStatistics:addNumberOfMisses(_numberOfMisses)
  self.numberOfMisses = self.numberOfMisses + _numberOfMisses
end


---
-- Calculates and returns the percentage of hit lines.
--
-- @treturn float The calculated percentage of hit lines
--
function HitMissStatistics:calculateHitPercentage()

  local totalNumberOfHittableLines = self.numberOfHits + self.numberOfMisses
  if (totalNumberOfHittableLines == 0) then
    return 0
  else
    return (self.numberOfHits / totalNumberOfHittableLines) * 100
  end

end


return HitMissStatistics
