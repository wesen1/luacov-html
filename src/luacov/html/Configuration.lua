---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"

---
-- Parses the HTML reporter configuration from a luacov configuration table.
--
-- @type Configuration
--
local Configuration = Object:extend()


---
-- The luacov configuration table
--
-- @tfield table luacovConfigurationTable
--
Configuration.luacovConfigurationTable = nil

---
-- The "html" configuration field of the luacov configuration table
--
-- @tfield table htmlReporterConfigurationTable
--
Configuration.htmlReporterConfigurationTable = nil


---
-- Configuration constructor.
--
-- @tparam table _luacovConfigurationTable The luacov configuration table
--
function Configuration:new(_luacovConfigurationTable)

  if (type(_luacovConfigurationTable) == "table") then
    self.luacovConfigurationTable = _luacovConfigurationTable
  else
    self.luacovConfigurationTable = {}
  end

  if (type(self.luacovConfigurationTable["html"]) == "table") then
    self.htmlReporterConfigurationTable = self.luacovConfigurationTable["html"]
  else
    self.htmlReporterConfigurationTable = {}
  end

end


-- Public Methods

---
-- Returns the "outputDirectory" config value or the default value if no config value is set.
--
-- @treturn string The "outputDirectory" config value
--
function Configuration:getOutputDirectoryPath()

  if (type(self.htmlReporterConfigurationTable["outputDirectory"]) == "string") then
    return self.htmlReporterConfigurationTable["outputDirectory"]
  else
    return "luacov-html"
  end

end

---
-- Returns the "projectName" config value or the default value if no config value is set.
--
-- @treturn string The "projectName" config value
--
function Configuration:getProjectName()

  if (type(self.htmlReporterConfigurationTable["projectName"]) == "string") then
    return self.htmlReporterConfigurationTable["projectName"]
  else
    return "All Files"
  end

end


return Configuration
