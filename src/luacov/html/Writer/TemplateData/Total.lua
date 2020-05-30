---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"

---
-- Provides the template data for Total coverage data objects.
--
-- @type Total
--
local Total = Object:extend()


---
-- The raw Total coverage data
--
-- @tfield CoverageData.Total totalCoverageData
--
Total.totalCoverageData = nil


---
-- Total constructor.
--
-- @tparam CoverageData.Total _totalCoverageData The raw Total coverage data
--
function Total:new(_totalCoverageData)
  self.totalCoverageData = _totalCoverageData
end


-- Public Methods

---
-- Generates and returns a regular table that contains all template values that are required to
-- visualize the raw Total coverage data.
--
-- @treturn table The template values
--
function Total:toTemplateValues()

  return {
    -- Base
    startTimestamp = self:getFormattedStartTimestamp()
  }

end


---
-- Returns the formatted start timestamp.
--
-- @treturn string The formatted start timestamp
--
function Total:getFormattedStartTimestamp()
  return os.date("%Y-%m-%d %H:%M:%S", self.totalCoverageData:getStartTimestamp())
end


return Total
