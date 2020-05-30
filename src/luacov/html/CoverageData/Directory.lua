---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local File = require "luacov.html.CoverageData.File"
local FileSystemEntryCollection = require "luacov.html.CoverageData.Util.FileSystemEntryCollection"
local FileSystemEntry = require "luacov.html.CoverageData.FileSystemEntry"

---
-- Contains coverage information about a directory and its child file system entries.
--
-- @type Directory
--
local Directory = FileSystemEntry:extend()


---
-- The collection for coverages of the child directories
--
-- @tfield FileSystemEntryCollection childDirectoryCoverageDataCollection
--
Directory.childDirectoryCoverageDataCollection = nil

---
-- The collection for coverages of the child files
--
-- @tfield FileSystemEntryCollection childFileCoverageDataCollection
--
Directory.childFileCoverageDataCollection = nil


---
-- Directory constructor.
--
-- @tparam string _directoryName The name of the directory
-- @tparam Directory _parentDirectoryCoverageData The coverage data of the parent directory
--
function Directory:new(_directoryName, _parentDirectoryCoverageData)
  FileSystemEntry.new(self, _directoryName, _parentDirectoryCoverageData)

  self.childDirectoryCoverageDataCollection = FileSystemEntryCollection(self, Directory)
  self.childFileCoverageDataCollection = FileSystemEntryCollection(self, File)
end


-- Public Methods

---
-- Returns the File coverage data for a given file path.
--
-- If the file is not a direct child of this Directory the request will be passed to the next child
-- Directory in the path.
--
-- A new File coverage data object will be created when there is no coverage data for the file yet.
--
-- @tparam string _filePath The file path whose File coverage data to return
--
-- @treturn File The File coverage data object for the file
--
function Directory:getOrCreateFileCoverageData(_filePath)

  local topDirectoryName, remainingPath = _filePath:match("^([^/]+)/(.+)")
  if (topDirectoryName) then
    -- This is not the parent directory, pass the request to the next child directory coverage
    local childDirectoryCoverageData = self.childDirectoryCoverageDataCollection:getOrCreateCoverageData(topDirectoryName)
    return childDirectoryCoverageData:getOrCreateFileCoverageData(remainingPath)

  else
    -- This is the parent directory, return the child file coverage
    return self.childFileCoverageDataCollection:getOrCreateCoverageData(_filePath)
  end

end

---
-- Returns a list of all child directory coverages sorted ascending by name.
--
-- @treturn Directory[] The sorted list of all child directory coverages
--
function Directory:getSortedChildDirectoryCoverages()
  return self.childDirectoryCoverageDataCollection:getSortedFileSystemEntryCoverages()
end

---
-- Returns a list of all child file coverages sorted ascending by name.
--
-- @treturn File[] The sorted list of all child file coverages
--
function Directory:getSortedChildFileCoverages()
  return self.childFileCoverageDataCollection:getSortedFileSystemEntryCoverages()
end


return Directory
