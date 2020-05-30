---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Directory = require "luacov.html.Writer.TemplateData.Directory"
local File = require "luacov.html.Writer.TemplateData.File"
local HitMissStatistics = require "luacov.html.Writer.TemplateData.HitMissStatistics"
local Line = require "luacov.html.Writer.TemplateData.Line"
local Object = require "classic"
local Total = require "luacov.html.Writer.TemplateData.Total"

---
-- Factory that should be used to create template data objects from coverage data objects.
--
-- @type TemplateDataFactory
--
local TemplateDataFactory = Object:extend()


---
-- The output path generator
--
-- @tfield OutputPathGenerator outputPathGenerator
--
TemplateDataFactory.outputPathGenerator = nil

---
-- The template data for the root directory
--
-- @tfield Directory rootDirectoryTemplateData
--
TemplateDataFactory.rootDirectoryTemplateData = nil


---
-- TemplateDataFactory constructor.
--
-- @tparam OutputPathGenerator _outputPathGenerator The output path generator
--
function TemplateDataFactory:new(_outputPathGenerator)
  self.outputPathGenerator = _outputPathGenerator
end


-- Public Methods

---
-- Sets the root directory that this factory should use for creating template data objects.
--
-- @tparam CoverageData.Directory _rootDirectoryCoverageData The coverage data of the root directory
--
function TemplateDataFactory:setRootDirectory(_rootDirectoryCoverageData)
  self.rootDirectoryTemplateData = self:createDirectoryTemplateData(_rootDirectoryCoverageData)
end


---
-- Creates and returns a Directory template data object from a Directory coverage data object.
--
-- @tparam CoverageData.Directory _directoryCoverageData The data to create a Directory template data object from
--
-- @treturn Directory The created Directory template data object
--
function TemplateDataFactory:createDirectoryTemplateData(_directoryCoverageData)
  return Directory(_directoryCoverageData, self.rootDirectoryTemplateData, self.outputPathGenerator, self)
end

---
-- Creates and returns a File template data object from a File coverage data object.
--
-- @tparam CoverageData.File _fileCoverageData The data to create a File template data object from
--
-- @treturn File The created File template data object
--
function TemplateDataFactory:createFileTemplateData(_fileCoverageData)
  return File(_fileCoverageData, self.rootDirectoryTemplateData, self.outputPathGenerator, self)
end

---
-- Creates and returns a Total template data object from a Total coverage data object.
--
-- @tparam CoverageData.Total _totalCoverageData The data to create a Total template data object from
--
-- @treturn Total The created Total template data object
--
function TemplateDataFactory:createTotalTemplateData(_totalCoverageData)
  return Total(_totalCoverageData)
end

---
-- Creates and returns a HitMissStatistics template data object from a HitMissStatistics coverage data object.
--
-- @tparam CoverageData.HitMissStatistics _hitMissStatisticsCoverageData The HitMissStatistics coverage data
--
-- @treturn HitMissStatistics The created HitMissStatistics template data object
--
function TemplateDataFactory:createHitMissStatisticsTemplateData(_hitMissStatisticsCoverageData)
  return HitMissStatistics(_hitMissStatisticsCoverageData)
end

---
-- Creates and returns a Line template data object from a Line coverage data object.
--
-- @tparam CoverageData.Line _lineCoverageData The Line coverage data
--
-- @treturn Line The created Line template data object
--
function TemplateDataFactory:createLineTemplateData(_lineCoverageData)
  return Line(_lineCoverageData)
end


return TemplateDataFactory
