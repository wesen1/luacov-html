---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"
local OutputPathGenerator = require "luacov.html.Writer.Path.OutputPathGenerator"
local TemplateDataFactory = require "luacov.html.Writer.TemplateData.TemplateDataFactory"
local TemplateFileCopier = require "luacov.html.Writer.Template.TemplateFileCopier"
local TemplateWriter = require "luacov.html.Writer.Template.TemplateWriter"

---
-- Generates and writes the HTML output for Total coverage data objects.
--
-- @type Writer
--
local Writer = Object:extend()


---
-- The template file copier
--
-- @tfield TemplateFileCopier templateFileCopier
--
Writer.templateFileCopier = nil

---
-- The template writer
--
-- @tfield TemplateWriter templateWriter
--
Writer.templateWriter = nil

---
-- The output path generator
--
-- @tfield OutputPathGenerator outputPathGenerator
--
Writer.outputPathGenerator = nil

---
-- The template data factory
--
-- @tfield TemplateDataFactory templateDataFactory
--
Writer.templateDataFactory = nil


---
-- Writer constructor.
--
-- @tparam string _baseOutputDirectoryPath The path to the base output directory
--
function Writer:new(_baseOutputDirectoryPath)

  self.outputPathGenerator = OutputPathGenerator(_baseOutputDirectoryPath)
  self.templateDataFactory = TemplateDataFactory(self.outputPathGenerator)
  self.templateFileCopier = TemplateFileCopier()
  self.templateWriter = TemplateWriter()

end


-- Public Methods

---
-- Generates and writese the HTML output for a Total coverage data object.
--
-- @tparam CoverageData.Total _totalCoverageData The Total coverage data object
--
function Writer:writeTotalCoverage(_totalCoverageData)

  local rootDirectoryCoverageData = _totalCoverageData:getRootDirectoryCoverageData()
  self.templateDataFactory:setRootDirectory(rootDirectoryCoverageData)

  local totalCoverageTemplateData = self.templateDataFactory:createTotalTemplateData(_totalCoverageData)
  self.templateWriter:addSharedTemplateValues(totalCoverageTemplateData:toTemplateValues())

  self:writeDirectoryCoverage(rootDirectoryCoverageData)

  self.templateFileCopier:copyTemplateFile(
    "style/reset.css",
    self.outputPathGenerator:generateOutputFilePathForRelativePath("style/reset.css")
  )
  self.templateFileCopier:copyTemplateFile(
    "style/style.css",
    self.outputPathGenerator:generateOutputFilePathForRelativePath("style/style.css")
  )

end


-- Private Methods

---
-- Generates and writes the HTML output for a Directory coverage data object.
--
-- @tparam CoverageData.Directory _directoryCoverageData The Directory coverage data object
--
function Writer:writeDirectoryCoverage(_directoryCoverageData)

  self:writeDirectoryPage(_directoryCoverageData)

  for _, fileCoverage in ipairs(_directoryCoverageData:getSortedChildFileCoverages()) do
    self:writeFilePage(fileCoverage)
  end

  for _, directoryCoverage in ipairs(_directoryCoverageData:getSortedChildDirectoryCoverages()) do
    self:writeDirectoryCoverage(directoryCoverage)
  end

end


---
-- Generates and writes the HTML page that visualizes a Directory coverage data object.
--
-- @tparam CoverageData.Directory _directoryCoverageData The Directory coverage data object
--
function Writer:writeDirectoryPage(_directoryCoverageData)

  local outputFilePath = self.outputPathGenerator:generateOutputFilePathForCoverageData(_directoryCoverageData)
  local templateData = self.templateDataFactory:createDirectoryTemplateData(_directoryCoverageData)
  local templateValues = templateData:toTemplateValues()

  self.templateWriter:writeTemplate(outputFilePath, "directory", templateValues)

end

---
-- Generates and writes the HTML page that visualizes a File coverage data object.
--
-- @tparam CoverageData.File _fileCoverageData The File coverage data object
--
function Writer:writeFilePage(_fileCoverageData)

  local outputFilePath = self.outputPathGenerator:generateOutputFilePathForCoverageData(_fileCoverageData)
  local templateData = self.templateDataFactory:createFileTemplateData(_fileCoverageData)
  local templateValues = templateData:toTemplateValues()

  self.templateWriter:writeTemplate(outputFilePath, "file", templateValues)

end


return Writer
