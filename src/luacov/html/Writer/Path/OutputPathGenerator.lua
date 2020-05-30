---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Directory = require "luacov.html.CoverageData.Directory"
local File = require "luacov.html.CoverageData.File"
local Object = require "classic"
local path = require "pl.path"

---
-- Generates the output file paths for the generated HTML files.
--
-- @type OutputPathGenerator
--
local OutputPathGenerator = Object:extend()


---
-- The path to the base output directory
--
-- @tfield string baseOutputDirectoryPath
--
OutputPathGenerator.baseOutputDirectoryPath = nil

---
-- The cached output file paths for FileSystemEntry coverage data objects
-- This list is in the format { [<CoverageData.FileSystemEntry>] = <outputFilePath>, ... }
--
-- @tfield table coverageDataOutputFilePaths
--
OutputPathGenerator.coverageDataOutputFilePaths = nil


---
-- OutputPathGenerator constructor.
--
-- @tparam string _baseOutputDirectoryPath The path to the base output directory
--
function OutputPathGenerator:new(_baseOutputDirectoryPath)
  self.baseOutputDirectoryPath = _baseOutputDirectoryPath
  self.coverageDataOutputFilePaths = {}
end


-- Public Methods

---
-- Generates a path to a FileSystemEntry coverage data object that is relative from another
-- FileSystemEntry coverage data object.
--
-- @tparam CoverageData.FileSystemEntry _fromFileSystemEntryCoverageData The start of the relative path
-- @tparam CoverageData.FileSystemEntry _toFileSystemEntryCoverageData The end of the relative path
-- @tparam bool _includeBaseName True to include the base name of the second FileSystemEntry in the generated path, false otherwise
--
-- @treturn string The relative path from the first FileSystemEntry to the other
--
function OutputPathGenerator:generateRelativePath(_fromFileSystemEntryCoverageData, _toFileSystemEntryCoverageData, _includeBaseName)

  local fromFullPath = self:generateOutputFilePathForCoverageData(_fromFileSystemEntryCoverageData)
  local toFullPath = self:generateOutputFilePathForCoverageData(_toFileSystemEntryCoverageData)

  local toFullPathDirectory, toFullPathBaseName = path.splitpath(toFullPath)
  local comparisonFromFullPath = "/" .. path.dirname(fromFullPath)
  local comparisonToFullPath = "/" .. toFullPathDirectory

  local relativePath = path.relpath(comparisonToFullPath, comparisonFromFullPath)
  if (relativePath == "") then
    relativePath = "."
  end

  relativePath = relativePath .. "/"

  if (_includeBaseName) then
    relativePath = relativePath .. toFullPathBaseName
  end

  return relativePath

end

---
-- Generates the full path for a FileSystemEntry's output HTML file.
--
-- @tparam CoverageData.FileSystemEntry _fileSystemEntryCoverageData The FileSystemEntry coverage data object
--
-- @treturn string The full path for the FileSystemEntry's output HTML file
--
function OutputPathGenerator:generateOutputFilePathForCoverageData(_fileSystemEntryCoverageData)

  if (self.coverageDataOutputFilePaths[_fileSystemEntryCoverageData] == nil) then

    local relativeParentDirectoryPath
    local fileName
    if (_fileSystemEntryCoverageData:is(Directory)) then
      relativeParentDirectoryPath = _fileSystemEntryCoverageData:calculateFullPath(false)
      fileName = "index.html"

    elseif (_fileSystemEntryCoverageData:is(File)) then
      relativeParentDirectoryPath = _fileSystemEntryCoverageData:getParentDirectoryCoverageData():calculateFullPath(false)
      fileName = _fileSystemEntryCoverageData:getBaseName():gsub("%.lua$", ".html")

    end

    self.coverageDataOutputFilePaths[_fileSystemEntryCoverageData] = self:generateOutputFilePathForRelativePath(
      relativeParentDirectoryPath .. "/" .. fileName
    )

  end

  return self.coverageDataOutputFilePaths[_fileSystemEntryCoverageData]

end

---
-- Generates the total output file path from a file path that is relative from the base output directory.
--
-- @tparam string _relativePath The relative path
--
-- @treturn string The total output file path
--
function OutputPathGenerator:generateOutputFilePathForRelativePath(_relativePath)
  return self.baseOutputDirectoryPath .. "/" .. _relativePath
end


return OutputPathGenerator
