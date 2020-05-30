---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Line = require "luacov.html.CoverageData.Line"
local FileSystemEntry = require "luacov.html.CoverageData.FileSystemEntry"
local tablex = require "pl.tablex"

---
-- Contains coverage information about a single file.
--
-- @type File
--
local File = FileSystemEntry:extend()


---
-- The coverage data for the lines in the file
--
-- @tfield Line[] lineCoverages
--
File.lineCoverages = nil


---
-- File constructor.
--
-- @tparam string _fileName The name of the file
-- @tparam Directory _parentDirectoryCoverageData The coverage data of the parent directory
--
function File:new(_fileName, _parentDirectoryCoverageData)
  FileSystemEntry.new(self, _fileName, _parentDirectoryCoverageData)
  self.lineCoverages = {}
end


-- Public Methods

---
-- Returns the line coverage data for the lines in the file sorted ascending by line number.
--
-- @treturn Line[] The line coverage data
--
function File:getSortedLineCoverages()

  local comparisonFunction = function(_lineCoverageDataA, _lineCoverageDataB)
    return _lineCoverageDataA:getLineNumber() < _lineCoverageDataB:getLineNumber()
  end

  local sortedLineCoverages = {}
  for _, lineCoverageData in tablex.sortv(self.lineCoverages, comparisonFunction) do
    table.insert(sortedLineCoverages, lineCoverageData)
  end

  return sortedLineCoverages

end


---
-- Adds an empty line to this File.
--
-- @tparam int _lineNumber The line number of the line
-- @tparam string _line The content of the line
--
function File:addEmptyLine(_lineNumber, _line)
  self:addLineCoverageData(Line(Line.TYPE_EMPTY, _line, _lineNumber))
end

---
-- Adds a missed line to this File.
--
-- @tparam int _lineNumber The line number of the line
-- @tparam string _line The content of the line
--
function File:addMissedLine(_lineNumber, _line)
  self:addLineCoverageData(Line(Line.TYPE_MISS, _line, _lineNumber))
end

---
-- Adds a hit line to this File.
--
-- @tparam int _lineNumber The line number of the line
-- @tparam string _line The content of the line
-- @tparam int _numberOfHits The number of times the line was executed
--
function File:addHitLine(_lineNumber, _line, _numberOfHits)
  self:addLineCoverageData(Line(Line.TYPE_HIT, _line, _lineNumber, _numberOfHits))
end


-- Private Methods

---
-- Adds a Line coverage data object to this File.
--
-- @tparam Line _lineCoverageData The Line coverage data to add
--
function File:addLineCoverageData(_lineCoverageData)
  self.lineCoverages[_lineCoverageData:getLineNumber()] = _lineCoverageData
end


return File
