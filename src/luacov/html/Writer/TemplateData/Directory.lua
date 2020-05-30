---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local FileSystemEntry = require "luacov.html.Writer.TemplateData.FileSystemEntry"
local tablex = require "pl.tablex"

---
-- Provides the template data for Directory coverage data objects.
--
-- @type Directory
--
local Directory = FileSystemEntry:extend()


-- Public Methods

---
-- Generates and returns a regular table that contains all template values that are required to
-- visualize the raw Directory coverage data.
--
-- @treturn table The template values
--
function Directory:toTemplateValues()

  local baseTemplateValues = FileSystemEntry.toTemplateValues(self)
  local directoryCoverageTemplateValues = {
    -- Content
    fileSystemEntries = self:generateChildFileSystemEntryTemplateValues()
  }

  return tablex.merge(baseTemplateValues, directoryCoverageTemplateValues, true)

end


---
-- Returns the report target name.
--
-- @treturn string The report target name
--
function Directory:getReportTargetName()
  return self.fileSystemEntryCoverageData:calculateFullPath(true)
end

---
-- Returns the template data objects of all child file system entries in the order in which
-- they should be displayed.
--
-- @treturn FileSystemEntry[] The template data objects of the child file system entries
--
function Directory:getChildFileSystemEntryTemplateDataObjects()

  local fileSystemEntryTemplateDataObjects = {}
  for _, directoryCoverageData in ipairs(self.fileSystemEntryCoverageData:getSortedChildDirectoryCoverages()) do
    table.insert(
      fileSystemEntryTemplateDataObjects,
      self.templateDataFactory:createDirectoryTemplateData(directoryCoverageData)
    )
  end

  for _, fileCoverageData in ipairs(self.fileSystemEntryCoverageData:getSortedChildFileCoverages()) do
    table.insert(
      fileSystemEntryTemplateDataObjects,
      self.templateDataFactory:createFileTemplateData(fileCoverageData)
    )
  end

  return fileSystemEntryTemplateDataObjects

end


-- Private Methods

---
-- Generates and returns a regular table that contains the template values that are required to
-- visualize all child file system entries.
--
-- @treturn table[] The template values
--
function Directory:generateChildFileSystemEntryTemplateValues()

  local fileSystemEntryTemplateValues = {}
  for _, fileSystemEntryTemplateData in ipairs(self:getChildFileSystemEntryTemplateDataObjects()) do

    table.insert(
      fileSystemEntryTemplateValues,
      {
        hitMissStatistics = fileSystemEntryTemplateData:getHitMissStatistics():toTemplateValues(),
        relativePath = fileSystemEntryTemplateData:getRelativePathFrom(self, true),
        name = fileSystemEntryTemplateData:getBaseName()
      }
    )

  end

  return fileSystemEntryTemplateValues

end


return Directory
