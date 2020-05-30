---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local FileSystemEntry = require "luacov.html.Writer.TemplateData.FileSystemEntry"
local tablex = require "pl.tablex"

---
-- Provides the template data for File coverage data objects.
--
-- @type File
--
local File = FileSystemEntry:extend()


-- Public Methods

---
-- Generates and returns a regular table that contains all template data that is required to
-- visualize the raw File coverage data.
--
-- @treturn table The template values
--
function File:toTemplateValues()

  local baseTemplateValues = FileSystemEntry.toTemplateValues(self)
  local fileCoverageTemplateValues = {
    -- Content
    lineCoverages = self:generateLineCoverageTemplateValues()
  }

  return tablex.merge(baseTemplateValues, fileCoverageTemplateValues, true)

end


---
-- Returns the report target name.
--
-- @treturn string The report target name
--
function File:getReportTargetName()
  return self:getClassName()
end

---
-- Returns the template data objects of all Line coverages in the order in which they should be displayed.
--
-- @treturn Line[] The template data objects of the Line coverages
--
function File:getLineCoverageTemplateDataObjects()

  local lineCoverageTemplateDataObjects = {}
  for _, lineCoverageData in ipairs(self.fileSystemEntryCoverageData:getSortedLineCoverages()) do
    table.insert(
      lineCoverageTemplateDataObjects,
      self.templateDataFactory:createLineTemplateData(lineCoverageData)
    )
  end

  return lineCoverageTemplateDataObjects

end


-- Private Methods

---
-- Returns the class name of the file.
--
-- @treturn string The class name
--
function File:getClassName()
  return self.fileSystemEntryCoverageData:getBaseName():gsub(".lua$", "")
end

---
-- Generates and returns a regular table that contains all data that is required
-- to visualize the Line coverage data.
--
-- @treturn table[] The template values
--
function File:generateLineCoverageTemplateValues()

  local lineCoverageTemplateValues = {}
  for _, lineCoverageTemplateData in ipairs(self:getLineCoverageTemplateDataObjects()) do
    table.insert(lineCoverageTemplateValues, lineCoverageTemplateData:toTemplateValues())
  end

  return lineCoverageTemplateValues

end


return File
