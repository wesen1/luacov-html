---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"
local tablex = require "pl.tablex"

---
-- Manages a list of FileSystemEntry coverage data objects.
--
-- @type FileSystemEntryCollection
--
local FileSystemEntryCollection = Object:extend()


---
-- The coverage data of the parent directory
--
-- @tfield Directory[] parentDirectoryCoverageData
--
FileSystemEntryCollection.parentDirectoryCoverageData = nil

---
-- The class to use to create new FileSystemEntry coverageD data objects
--
-- @tfield FileSystemEntry coverageDataClass
--
FileSystemEntryCollection.coverageDataClass = nil

---
-- The list of FileSystemEntry coverages
--
-- @tfield FileSystemEntry[] fileSystemEntryCoverages
--
FileSystemEntryCollection.fileSystemEntryCoverages = nil


---
-- FileSystemEntryCollection constructor.
--
-- @tparam Directory _parentDirectoryCoverageData The coverage data of the parent directory
-- @tparam FileSystemEntry _coverageDataClass The class to use to create new FileSystemEntry coverage data objects
--
function FileSystemEntryCollection:new(_parentDirectoryCoverageData, _coverageDataClass)
  self.parentDirectoryCoverageData = _parentDirectoryCoverageData
  self.coverageDataClass = _coverageDataClass
  self.fileSystemEntryCoverages = {}
end


-- Public Methods

---
-- Returns the FileSystemEntry coverage data for a given base name.
-- A new FileSystemEntry coverage data object will be created if none exists yet for that name.
--
-- @tparam string _baseName The base name whose FileSystemEntry coverage data to return
--
-- @treturn FileSystemEntry The coverage data for the FileSystemEntry
--
function FileSystemEntryCollection:getOrCreateCoverageData(_baseName)
  if (not self.fileSystemEntryCoverages[_baseName]) then
    self.fileSystemEntryCoverages[_baseName] = self.coverageDataClass(_baseName, self.parentDirectoryCoverageData)
  end

  return self.fileSystemEntryCoverages[_baseName]
end


---
-- Returns a list of all FileSystemEntry coverages sorted ascending by name.
--
-- @treturn FileSystemEntry[] The sorted list of all FileSystemEntry coverages
--
function FileSystemEntryCollection:getSortedFileSystemEntryCoverages()

  local comparisonFunction = function(_fileSystemEntryCoverageA, _fileSystemEntryCoverageB)
    return _fileSystemEntryCoverageA:getBaseName() < _fileSystemEntryCoverageB:getBaseName()
  end

  local sortedFileSystemEntryCoverages = {}
  for _, fileSystemEntryCoverageData in tablex.sortv(self.fileSystemEntryCoverages, comparisonFunction) do
    table.insert(sortedFileSystemEntryCoverages, fileSystemEntryCoverageData)
  end

  return sortedFileSystemEntryCoverages

end


return FileSystemEntryCollection
