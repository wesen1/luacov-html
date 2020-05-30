---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"

---
-- Provides the template data for HitMissStatistics coverage data objects.
--
-- @type HitMissStatistics
--
local HitMissStatistics = Object:extend()


---
-- The raw HitMissStatistics data
--
-- @tfield CoverageData.HitMissStatistics hitMissStatisticsData
--
HitMissStatistics.hitMissStatisticsData = nil


---
-- HitMissStatistics constructor.
--
-- @tparam CoverageData.HitMissStatistics _hitMissStatisticsData The raw HitMissStatistics data
--
function HitMissStatistics:new(_hitMissStatisticsData)
  self.hitMissStatisticsData = _hitMissStatisticsData
end


-- Public Methods

---
-- Generates and returns a regular table that contains all template values that are required to
-- visualize the raw HitMissStatistics data.
--
-- @treturn table The template values
--
function HitMissStatistics:toTemplateValues()

  return {
    numberOfHits = self:getNumberOfHits(),
    numberOfMisses = self:getNumberOfMisses(),
    formattedHitPercentage = self:getFormattedHitPercentage(),
    hitPercentageStatusText = self:getHitPercentageStatusText()
  }

end


---
-- Returns the number of hit lines.
--
-- @treturn int The number of hit lines
--
function HitMissStatistics:getNumberOfHits()
  return self.hitMissStatisticsData:getNumberOfHits()
end

---
-- Returns the number of missed lines.
--
-- @treturn int The number of missed lines
--
function HitMissStatistics:getNumberOfMisses()
  return self.hitMissStatisticsData:getNumberOfMisses()
end

---
-- Returns the formatted percentage of hit lines.
--
-- @treturn string The formatted percentage of hit lines
--
function HitMissStatistics:getFormattedHitPercentage()
  return string.format("%.2f", self.hitMissStatisticsData:calculateHitPercentage())
end

---
-- Returns a status text that identifies the range in which the hit percentage is located.
--
-- @treturn string The status text
--
function HitMissStatistics:getHitPercentageStatusText()

  local rate = self.hitMissStatisticsData:calculateHitPercentage()
  if (rate > 80.0) then
    return "high"
  elseif (rate >= 50.0) then
    return "medium"
  else
    return "low"
  end

end


return HitMissStatistics
