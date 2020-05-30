---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local reporter = require "luacov.reporter"
local ReporterBase = reporter.ReporterBase
local Configuration = require "luacov.html.Configuration"
local Total = require "luacov.html.CoverageData.Total"
local Writer = require "luacov.html.Writer.Writer"

---
-- Luacov Reporter that generates HTML files to visualize the coverage of lines, files and directories.
--
-- @type HtmlReporter
--
local HtmlReporter = setmetatable({}, ReporterBase)
HtmlReporter.__index = HtmlReporter


---
-- The Total coverage data
--
-- @tfield CoverageData.Total totalCoverageData
--
HtmlReporter.totalCoverageData = nil

---
-- The Writer that generates HTML files from the Total coverage data
--
-- @tfield Writer writer
--
HtmlReporter.writer = nil


---
-- Reporter constructor.
--
-- @tparam table _luacovConfigurationTable The luacov configuration table
--
-- @treturn Reporter The HtmlReporter instance
--
function HtmlReporter:new(_luacovConfigurationTable)

  local object, errorMessage = ReporterBase.new(self, _luacovConfigurationTable)
	if not object then
		return nil, errorMessage
	end

  -- Parse the configuration
  local configuration = Configuration(_luacovConfigurationTable)

  -- Initialize the object attributes
  object.totalCoverageData = Total(configuration:getProjectName())
  object.totalCoverageWriter = Writer(configuration:getOutputDirectoryPath())

	return object

end


-- Luacov stub methods

---
-- Stub method called before reporting.
--
function HtmlReporter:on_start()
  self.totalCoverageData:setStartTimestamp(os.time())
end

---
-- Stub method called for each empty source line and other lines that can't be hit.
--
-- @tparam string _filePath The file path
-- @tparam int _lineNumber The line number of the line
-- @tparam string _line The content of the line
--
function HtmlReporter:on_empty_line(_filePath, _lineNumber, _line)
  self.totalCoverageData:addEmptyLine(_filePath, _lineNumber, _line)
end

---
-- Stub method called for each missed source line.
--
-- @tparam string _filePath The file path
-- @tparam int _lineNumber The line number of the line
-- @tparam string _line The content of the line
--
function HtmlReporter:on_mis_line(_filePath, _lineNumber, _line)
  self.totalCoverageData:addMissedLine(_filePath, _lineNumber, _line)
end

---
-- Stub method called for each hit source line.
--
-- @tparam string _filePath The file path
-- @tparam int _lineNumber The line number of the line
-- @tparam string _line The content of the line
-- @tparam int _numberOfHits The number of times the line was executed
--
function HtmlReporter:on_hit_line(_filePath, _lineNumber, _line, _numberOfHits)
  self.totalCoverageData:addHitLine(_filePath, _lineNumber, _line, _numberOfHits)
end

---
-- Stub method called after a file has been processed.
--
-- @tparam string _filePath The file path
-- @tparam int _numberOfHits The total number of hits in the file
-- @tparam int _numberOfMisses The total number of misses in the file
--
function HtmlReporter:on_end_file(_filePath, _numberOfHits, _numberOfMisses)
  self.totalCoverageData:addFileHitMissStatistics(_filePath, _numberOfHits, _numberOfMisses)
end

---
-- Stub method called after reporting.
--
function HtmlReporter:on_end()
  self.totalCoverageWriter:writeTotalCoverage(self.totalCoverageData)
end


return {

	HtmlReporter = HtmlReporter,

	report = function ()
		return reporter.report(HtmlReporter)
	end
}
