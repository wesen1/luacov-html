---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local HitMissStatistics = require "luacov.html.CoverageData.Util.HitMissStatistics"
local Object = require "classic"

---
-- Base class for coverages of file system entries (directories or files).
--
-- @type FileSystemEntry
--
local FileSystemEntry = Object:extend()


---
-- The base name of the file system entry
--
-- @tfield string baseName
--
FileSystemEntry.baseName = nil

---
-- The coverage data of the parent directory
--
-- @tfield Directory parentDirectoryCoverageData
--
FileSystemEntry.parentDirectoryCoverageData = nil

---
-- The hit/miss statistics for the file system entry
--
-- @tfield HitMissStatistics hitMissStatistics
--
FileSystemEntry.hitMissStatistics = nil


---
-- FileSystemEntry constructor.
--
-- @tparam string _baseName The base name of the file system entry
-- @tparam Directory _parentDirectoryCoverageData The coverage data of the parent directory
--
function FileSystemEntry:new(_baseName, _parentDirectoryCoverageData)
  self.baseName = _baseName
  self.parentDirectoryCoverageData = _parentDirectoryCoverageData
  self.hitMissStatistics = HitMissStatistics()
end


-- Getters and setters

---
-- Returns the base name of the file system entry.
--
-- @treturn string The base name
--
function FileSystemEntry:getBaseName()
  return self.baseName
end

---
-- Returns the coverage data of the parent directory.
--
-- @treturn Directory The coverage data of the parent directory
--
function FileSystemEntry:getParentDirectoryCoverageData()
  return self.parentDirectoryCoverageData
end

---
-- Returns the hit/miss statistics for the file system entry.
--
-- @treturn HitMissStatistics The hit/miss statistics
--
function FileSystemEntry:getHitMissStatistics()
  return self.hitMissStatistics
end


-- Public Methods

---
-- Calculates and returns all directory coverages between this file system entry and
-- the root coverage directory.
--
-- The directory coverages are ordered ascending by their distance to the root coverage directory.
--
-- @tparam bool _includeRoot True to include the root directory coverage in the list, false otherwise
-- @tparam bool _includeSelf True to include this FileSystemEntry in the list (used for recursion)
--
-- @treturn Directory[] The directory coverages
--
function FileSystemEntry:calculatePathDirectoryCoverages(_includeRoot, _includeSelf)

  local pathDirectoryCoverages
  if (self.parentDirectoryCoverageData) then
    pathDirectoryCoverages = self.parentDirectoryCoverageData:calculatePathDirectoryCoverages(_includeRoot, true)

    if (_includeSelf) then
      table.insert(pathDirectoryCoverages, self)
    end

  else
    -- This is the root directory coverage
    if (_includeRoot and _includeSelf) then
      pathDirectoryCoverages = { self }
    else
      pathDirectoryCoverages = {}
    end
  end

  return pathDirectoryCoverages

end

---
-- Calculates and returns the full path of this file system entry relative from the root coverage directory.
--
-- @tparam bool _includeRoot True to include the root directory in the path, false otherwise
--
-- @treturn string The calculated path
--
function FileSystemEntry:calculateFullPath(_includeRoot)

  local pathDirectoryNames = {}
  for _, directoryCoverage in ipairs(self:calculatePathDirectoryCoverages(_includeRoot)) do
    table.insert(pathDirectoryNames, directoryCoverage:getBaseName())
  end

  if (#pathDirectoryNames == 0) then
    if (_includeRoot or self.parentDirectoryCoverageData) then
      -- The root directory should be included in the path or this is not the root directory
      return self.baseName
    else
      return ""
    end
  else
    return table.concat(pathDirectoryNames, "/") .. "/" .. self.baseName
  end

end

---
-- Adds hit/miss statistics to this FileSystemEntry and all of its parent directory coverages.
--
-- @tparam int _numberOfHits The number of hit lines to add
-- @tparam int _numberOfMisses The number of missed lines to add
--
function FileSystemEntry:addHitMissStatistics(_numberOfHits, _numberOfMisses)
  self.hitMissStatistics:addNumberOfHits(_numberOfHits)
  self.hitMissStatistics:addNumberOfMisses(_numberOfMisses)

  if (self.parentDirectoryCoverageData) then
    self.parentDirectoryCoverageData:addHitMissStatistics(_numberOfHits, _numberOfMisses)
  end
end


return FileSystemEntry
