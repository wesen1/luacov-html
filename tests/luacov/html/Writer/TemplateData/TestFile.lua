---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local FileSystemEntryTestBase = require "tests.luacov.html.Writer.TemplateData.FileSystemEntryTestBase"

---
-- Checks that the TemplateData.File class works as expected.
--
-- @type TestFile
--
local TestFile = FileSystemEntryTestBase:extend()


---
-- The require path for the class that is tested by this TestCase
--
-- @tfield string testClassPath
--
TestFile.testClassPath = "luacov.html.Writer.TemplateData.File"


-- Public Methods

---
-- Checks that the report target name can be returned as expected.
--
function TestFile:testCanReturnReportTargetName()

  local file = self:createFileSystemEntryInstance()

  local reportTargetName
  self.fileSystemEntryCoverageDataMock.getBaseName
                                      :should_be_called()
                                      :and_will_return("Triangle.lua")
                                      :when(
                                        function()
                                          reportTargetName = file:getReportTargetName()
                                        end
                                      )

  self:assertEquals(reportTargetName, "Triangle")

end

---
-- Checks that the TemplateData.Line's can be returned as expected.
--
function TestFile:testCanReturnLineCoverageTemplateDataObjects()

  local file = self:createFileSystemEntryInstance()

  self.fileSystemEntryCoverageDataMock.getSortedLineCoverages = self.mach.mock_method("getSortedLineCoverages")

  local lineCoverageDataMocks = {
    self:getMock("luacov.html.CoverageData.Line", "LineCoverageDataMockA"),
    self:getMock("luacov.html.CoverageData.Line", "LineCoverageDataMockB"),
    self:getMock("luacov.html.CoverageData.Line", "LineCoverageDataMockC")
  }
  local lineTemplateDataMocks = {
    self:getMock("luacov.html.Writer.TemplateData.Line", "LineTemplateDataMockA"),
    self:getMock("luacov.html.Writer.TemplateData.Line", "LineTemplateDataMockB"),
    self:getMock("luacov.html.Writer.TemplateData.Line", "LineTemplateDataMockC")
  }

  local lineCoverageTemplateDataObjects
  self.fileSystemEntryCoverageDataMock.getSortedLineCoverages
                                      :should_be_called()
                                      :and_will_return(lineCoverageDataMocks)
                                      :and_then(
                                        self.templateDataFactoryMock.createLineTemplateData
                                                                    :should_be_called_with(
                                                                      lineCoverageDataMocks[1]
                                                                    )
                                                                    :and_will_return(
                                                                      lineTemplateDataMocks[1]
                                                                    )
                                      )
                                      :and_also(
                                        self.templateDataFactoryMock.createLineTemplateData
                                                                    :should_be_called_with(
                                                                      lineCoverageDataMocks[2]
                                                                    )
                                                                    :and_will_return(
                                                                      lineTemplateDataMocks[2]
                                                                    )
                                      )
                                      :and_also(
                                        self.templateDataFactoryMock.createLineTemplateData
                                                                    :should_be_called_with(
                                                                      lineCoverageDataMocks[3]
                                                                    )
                                                                    :and_will_return(
                                                                      lineTemplateDataMocks[3]
                                                                    )
                                      )
                                      :when(
                                        function()
                                          lineCoverageTemplateDataObjects = file:getLineCoverageTemplateDataObjects()
                                        end
                                      )

  self:assertEquals(lineCoverageTemplateDataObjects, lineTemplateDataMocks)

end


---
-- Checks that the template values can be generated as expected.
--
function TestFile:testCanBeConvertedToTemplateValues()

  local file = self:createFileSystemEntryInstance()

  local pathPartTemplateValues = {
    { baseName = "All Files", relativePath = "../../../" },
    { baseName = "src", relativePath = "../../" },
    { baseName = "my_example", relativePath = "../" },
    { baseName = "dir", relativePath = "./" }
  }

  local hitMissStatisticsTemplateValues = {
    numberOfHits = 53,
    numberOfMisses = 31,
    formattedHitPercentage = "63.10",
    hitPercentageStatusText = "medium"
  }

  local lineCoverageTemplateValues = {
    {
      line = "-- Calculate the value",
      lineNumber = 1,
      numberOfHitsText = "\n",
      coverageType = "empty"
    },
    {
      line = "local value = 1 + 1",
      lineNumber = 2,
      numberOfHitsText = "3x",
      coverageType = "hit"
    },
    {
      line = "print(\"1 + 1 equals \" .. value)",
      lineNumber = 3,
      numberOfHitsText = "3x",
      coverageType = "hit"
    }
  }

  local templateValues
  self:expectRelativePathToRootCalculation(file, "../../../")
      :and_also(
        self:expectReportTargetNameFetching("Square.lua")
      )
      :and_also(
        self:expectPathPartTemplateValuesGeneration(file, pathPartTemplateValues)
      )
      :and_also(
       self:expectBaseNameFetching("Square.lua")
      )
      :and_also(
       self:expectHitMissStatisticsTemplateValueGeneration(hitMissStatisticsTemplateValues)
      )
      :and_also(
        self:expectLineCoverageTemplateValuesGeneration(lineCoverageTemplateValues)
      )
      :when(
        function()
          templateValues = file:toTemplateValues()
        end
      )


  local expectedTemplateValues = {

    relativePathToRoot = "../../../",
    reportTarget = "Square",

    pathParts = {
      { name = "All Files", relativePath = "../../../" },
      { name = "src", relativePath = "../../" },
      { name = "my_example", relativePath = "../" },
      { name = "dir", relativePath = "./" }
    },

    baseName = "Square.lua",

    hitMissStatistics = {
      numberOfHits = 53,
      numberOfMisses = 31,
      formattedHitPercentage = "63.10",
      hitPercentageStatusText = "medium"
    },

    lineCoverages = {
      {
        line = "-- Calculate the value",
        lineNumber = 1,
        numberOfHitsText = "\n",
        coverageType = "empty"
      },
      {
        line = "local value = 1 + 1",
        lineNumber = 2,
        numberOfHitsText = "3x",
        coverageType = "hit"
      },
      {
        line = "print(\"1 + 1 equals \" .. value)",
        lineNumber = 3,
        numberOfHitsText = "3x",
        coverageType = "hit"
      }
    }
  }

  self:assertEquals(templateValues, expectedTemplateValues)

end


-- Private Methods

---
-- Returns the required expectations for the fetching of the report target name of the test File instance.
--
-- @tparam string _baseName The base name to return
--
-- @treturn table The expectations
--
function TestFile:expectReportTargetNameFetching(_baseName)

  return self.fileSystemEntryCoverageDataMock.getBaseName
                                             :should_be_called()
                                             :and_will_return(_baseName)

end

---
-- Returns the required expectations for the generation of the line coverage template values
-- of the test File instance.
--
-- @tparam table[] _lineCoverageTemplateValues The line coverage template values to return
--
-- @treturn table The expectations
--
function TestFile:expectLineCoverageTemplateValuesGeneration(_lineCoverageTemplateValues)

  self.fileSystemEntryCoverageDataMock.getSortedLineCoverages = self.mach.mock_method("getSortedLineCoverages")

  -- Generate line coverage mocks and line template data mocks
  local lineCoverageMocks = {}
  local lineCoverageMockExpectations, lineTemplateDataMockExpectations
  local lineCoverageMock, lineTemplateDataMock, coverageDataMockExpectation, templateDataMockExpectation

  for i = 1, #_lineCoverageTemplateValues, 1 do

    lineCoverageMock = self:getMock("luacov.html.CoverageData.Line", "LineCoverageDataMock_" .. i)
    lineTemplateDataMock = self:getMock("luacov.html.Writer.TemplateData.Line", "LineTemplateDataMock_" .. i)

    coverageDataMockExpectation = self.templateDataFactoryMock.createLineTemplateData
                                                              :should_be_called_with(lineCoverageMock)
                                                              :and_will_return(lineTemplateDataMock)

    templateDataMockExpectation = lineTemplateDataMock.toTemplateValues
                                                      :should_be_called()
                                                      :and_will_return(_lineCoverageTemplateValues[i])

    if (i == 1) then
      lineCoverageMockExpectations = coverageDataMockExpectation
      lineTemplateDataMockExpectations = templateDataMockExpectation
    else
      lineCoverageMockExpectations:and_also(coverageDataMockExpectation)
      lineTemplateDataMockExpectations:and_also(templateDataMockExpectation)
    end

    lineCoverageMocks[i] = lineCoverageMock

  end


  local expectations = self.fileSystemEntryCoverageDataMock.getSortedLineCoverages
                                                           :should_be_called()
                                                           :and_will_return(lineCoverageMocks)

  if (lineCoverageMockExpectations) then
    expectations:and_then(lineCoverageMockExpectations)
  end

  if (lineTemplateDataMockExpectations) then
    expectations:and_then(lineTemplateDataMockExpectations)
  end

  return expectations

end


return TestFile
