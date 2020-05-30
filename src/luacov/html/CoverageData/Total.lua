---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Directory = require "luacov.html.CoverageData.Directory"
local FilePathNormalizer = require "luacov.html.CoverageData.Util.FilePathNormalizer"
local Object = require "classic"

---
-- Contains the total coverage data for all directories and files.
--
-- @type Total
--
local Total = Object:extend()


---
-- The file path normalizer
--
-- @tfield FilePathNormalizer filePathNormalizer
--
Total.filePathNormalizer = nil

---
-- The coverage data of the root directory
--
-- @tfield Directory rootDirectoryCoverageData
--
Total.rootDirectoryCoverageData = nil

---
-- The timestamp when the coverage report generation was started
--
-- @tfield int startTimestamp
--
Total.startTimestamp = nil

---
-- The file path of the last fetched File coverage data object
-- This is used to check if the last fetched File coverage data object can be reused instead of
-- fetching the same object again
--
-- @tfield string lastFetchedFileCoverageFilePath
--
Total.lastFetchedFileCoverageDataFilePath = nil

---
-- The last fetched File coverage data object
--
-- @tfield File lastFetchedFileCoverageData
--
Total.lastFetchedFileCoverageData = nil


---
-- Total constructor.
--
-- @tparam string _projectName The project name
--
function Total:new(_projectName)

  self.filePathNormalizer = FilePathNormalizer()

  -- The root directory has no parent directory
  self.rootDirectoryCoverageData = Directory(_projectName)
end


-- Getters and Setters

---
-- Returns the coverage data of the root directory.
--
-- @treturn Directory The coverage data of the root directory
--
function Total:getRootDirectoryCoverageData()
  return self.rootDirectoryCoverageData
end

---
-- Sets the timestamp when the coverage report generation was started.
--
-- @tparam int _startTimestamp The timestamp
--
function Total:setStartTimestamp(_startTimestamp)
  self.startTimestamp = _startTimestamp
end

---
-- Returns the timestamp when the coverage report generation was started.
--
-- @treturn int The timestamp
--
function Total:getStartTimestamp()
  return self.startTimestamp
end


-- Public Methods

---
-- Adds an empty line to this Total coverage data.
--
-- @tparam string _filePath The file path
-- @tparam int _lineNumber The line number of the line
-- @tparam string _line The content of the line
--
function Total:addEmptyLine(_filePath, _lineNumber, _line)
  local fileCoverageData = self:getOrCreateFileCoverageData(_filePath)
  fileCoverageData:addEmptyLine(_lineNumber, _line)
end

---
-- Adds a missed line to this Total coverage data.
--
-- @tparam string _filePath The file path
-- @tparam int _lineNumber The line number of the line
-- @tparam string _line The content of the line
--
function Total:addMissedLine(_filePath, _lineNumber, _line)
  local fileCoverageData = self:getOrCreateFileCoverageData(_filePath)
  fileCoverageData:addMissedLine(_lineNumber, _line)
end

---
-- Adds a hit line to this Total coverage data.
--
-- @tparam string _filePath The file path
-- @tparam int _lineNumber The number of the line
-- @tparam string _line The content of the line
-- @tparam int _numberOfHits The number of times the line was executed
--
function Total:addHitLine(_filePath, _lineNumber, _line, _numberOfHits)
  local fileCoverageData = self:getOrCreateFileCoverageData(_filePath)
  fileCoverageData:addHitLine(_lineNumber, _line, _numberOfHits)
end

---
-- Adds hit/miss statistics to this Total coverage data.
--
-- @tparam string _filePath The file path
-- @tparam int _numberOfHits The total number of hits in the file
-- @tparam int _numberOfMisses The total number of misses in the file
--
function Total:addFileHitMissStatistics(_filePath, _numberOfHits, _numberOfMisses)

  -- The hit/miss statistics will be added recursively upwards the file's path
  local fileCoverage = self:getOrCreateFileCoverageData(_filePath)
  fileCoverage:addHitMissStatistics(_numberOfHits, _numberOfMisses)

end


-- Private Methods

---
-- Returns the File coverage data for a specified file.
-- A new File coverage data object will be created if there is none for that file yet.
--
-- @tparam string _filePath The file path whose File coverage data to return
--
-- @treturn File The file coverage data for the specified file
--
function Total:getOrCreateFileCoverageData(_filePath)

  if (not self.lastFetchedFileCoverageData or _filePath ~= self.lastFetchedFileCoverageDataFilePath) then
    local normalizeFilePath = self.filePathNormalizer:normalizeFilePath(_filePath)
    local fileCoverageData = self.rootDirectoryCoverageData:getOrCreateFileCoverageData(normalizeFilePath)

    self.lastFetchedFileCoverageData = fileCoverageData
    self.lastFetchedFileCoverageDataFilePath = _filePath
  end

  return self.lastFetchedFileCoverageData

end


return Total
