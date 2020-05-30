---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"

---
-- Provides the shared template data of Directory's and File's.
--
-- @type FileSystemEntry
--
local FileSystemEntry = Object:extend()


---
-- The raw FileSystemEntry coverage data
--
-- @tfield CoverageData.FileSystemEntry fileSystemEntryCoverageData
--
FileSystemEntry.fileSystemEntryCoverageData = nil

---
-- The template data of the root directory
-- This is used to calculate the relative path to the root directory
--
-- @tfield Directory rootDirectoryTemplateData
--
FileSystemEntry.rootDirectoryTemplateData = nil

---
-- The output path generator
--
-- @tfield OutputPathGenerator outputPathGenerator
--
FileSystemEntry.outputPathGenerator = nil

---
-- The TemplateData factory
--
-- @tfield TemplateDataFactory templateDataFactory
--
FileSystemEntry.templateDataFactory = nil


---
-- FileSystemEntry constructor.
--
-- @tparam CoverageData.FileSystemEntry _fileSystemEntryCoverageData The raw FileSystemEntry coverage data
-- @tparam Directory _rootDirectoryTemplateData The template data of the root directory
-- @tparam OutputPathGenerator _outputPathGenerator The output path generator
-- @tparam TemplateDataFactory _templateDataFactory The TemplateData factory
--
function FileSystemEntry:new(_fileSystemEntryCoverageData, _rootDirectoryTemplateData, _outputPathGenerator, _templateDataFactory)
  self.fileSystemEntryCoverageData = _fileSystemEntryCoverageData
  self.rootDirectoryTemplateData = _rootDirectoryTemplateData
  self.outputPathGenerator = _outputPathGenerator
  self.templateDataFactory = _templateDataFactory
end


-- Getters and Setters

---
-- Returns the raw FileSystemEntry coverage data.
--
-- @treturn CoverageData.FileSystemEntry The raw FileSystemEntry coverage data
--
function FileSystemEntry:getFileSystemEntryCoverageData()
  return self.fileSystemEntryCoverageData
end


-- Public Methods

---
-- Generates and returns a regular table that contains all template data that is required to
-- visualize the raw FileSystemEntry coverage data.
--
-- @treturn table The template values
--
function FileSystemEntry:toTemplateValues()

  return {

    -- Base
    relativePathToRoot = self:getRelativePathToRoot(),
    reportTarget = self:getReportTargetName(),

    -- Navigatable Path
    pathParts = self:generatePathPartTemplateValues(),
    baseName = self:getBaseName(),

    -- Hit miss statistics
    hitMissStatistics = self:getHitMissStatistics():toTemplateValues()
  }

end


---
-- Returns the relative path from the file system entry to the root directory.
--
-- @treturn string The relative path to the root directory
--
function FileSystemEntry:getRelativePathToRoot()
  return self.rootDirectoryTemplateData:getRelativePathFrom(self, false)
end

---
-- Returns the relative path from another file system entry to this file system entry.
--
-- @tparam FileSystemEntry _fileSystemEntryTemplateData The other file system entry
-- @tparam bool _includeBaseName True to include the base name in the relative path, false otherwise
--
-- @treturn string The relative path from the other file system entry to this file system entry
--
function FileSystemEntry:getRelativePathFrom(_fileSystemEntryTemplateData, _includeBaseName)

  local fromFileSystemEntryCoverageData = _fileSystemEntryTemplateData:getFileSystemEntryCoverageData()
  local toFileSystemEntryCoverageData = self.fileSystemEntryCoverageData

  return self.outputPathGenerator:generateRelativePath(
    fromFileSystemEntryCoverageData, toFileSystemEntryCoverageData, _includeBaseName
  )

end

---
-- Returns the report target name.
-- This is an abstract method that must be implemented by child classes.
--
-- @treturn string The report target name
--
function FileSystemEntry:getReportTargetName()
end

---
-- Returns the Directory template data objects for all path parts of the file system entry
-- including the root directory.
--
-- @treturn Directory[] The Directory template data objects for all path parts
--
function FileSystemEntry:getPathPartTemplateDataObjects()

  local pathPartTemplateDataObjects = {}
  for _, directoryCoverageData in ipairs(self.fileSystemEntryCoverageData:calculatePathDirectoryCoverages(true, false)) do

    table.insert(
      pathPartTemplateDataObjects,
      self.templateDataFactory:createDirectoryTemplateData(directoryCoverageData)
    )

  end

  return pathPartTemplateDataObjects

end

---
-- Returns the base name of the file system entry.
--
-- @treturn string The base name
--
function FileSystemEntry:getBaseName()
  return self.fileSystemEntryCoverageData:getBaseName()
end

---
-- Returns the hit/miss statistics of the file system entry.
--
-- @treturn HitMissStatistics The hit/miss statistics
--
function FileSystemEntry:getHitMissStatistics()
  return self.templateDataFactory:createHitMissStatisticsTemplateData(
    self.fileSystemEntryCoverageData:getHitMissStatistics()
  )
end


-- Private Methods

---
-- Generates and returns a regular table that contains all data that is required
-- to visualize the path parts.
--
-- @treturn table[] The template values
--
function FileSystemEntry:generatePathPartTemplateValues()

  local pathPartTemplateValues = {}
  for _, directoryTemplateData in ipairs(self:getPathPartTemplateDataObjects()) do
    table.insert(
      pathPartTemplateValues,
      {
        name = directoryTemplateData:getBaseName(),
        relativePath = directoryTemplateData:getRelativePathFrom(self, true)
      }
    )
  end

  return pathPartTemplateValues

end


return FileSystemEntry
