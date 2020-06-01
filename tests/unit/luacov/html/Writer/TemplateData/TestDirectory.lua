---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local FileSystemEntryTestBase = require "tests.unit.luacov.html.Writer.TemplateData.FileSystemEntryTestBase"

---
-- Checks that the TemplateData.Directory class works as expected.
--
-- @type TestDirectory
--
local TestDirectory = FileSystemEntryTestBase:extend()


---
-- The require path for the class that is tested by this TestCase
--
-- @tfield string testClassPath
--
TestDirectory.testClassPath = "luacov.html.Writer.TemplateData.Directory"


-- Public Methods

---
-- Checks that the relative path to the root directory can be returned as expected when no
-- root directory template data is passed to the Directory's constructor.
--
function TestDirectory:testCanReturnRelativePathToRootIfRootDirectoryTemplateDataIsNil()

  local Directory = self.testClass

  local directory
  self.fileSystemEntryCoverageDataMock.getParentDirectoryCoverageData
                                      :should_be_called()
                                      :and_will_return(nil)
                                      :when(
                                        function()
                                          directory = Directory(
                                            self.fileSystemEntryCoverageDataMock,
                                            nil,
                                            self.outputPathGeneratorMock,
                                            self.templateDataFactoryMock
                                          )
                                        end
                                      )

  local relativePathToRoot
  self.outputPathGeneratorMock.generateRelativePath
                              :should_be_called_with(
                                self.fileSystemEntryCoverageDataMock,
                                self.fileSystemEntryCoverageDataMock,
                                false
                              )
                              :and_will_return("./")
                              :when(
                                function()
                                  relativePathToRoot = directory:getRelativePathToRoot()
                                end
                              )

  self:assertEquals(relativePathToRoot, "./")

end

---
-- Checks that the report target name can be returned as expected.
--
function TestDirectory:testCanReturnReportTargetName()

  local directory = self:createFileSystemEntryInstance()

  local reportTargetName
  self.fileSystemEntryCoverageDataMock.calculateFullPath
                                      :should_be_called_with(true)
                                      :and_will_return("root/this/is/the/dir")
                                      :when(
                                        function()
                                          reportTargetName = directory:getReportTargetName()
                                        end
                                      )

  self:assertEquals(reportTargetName, "root/this/is/the/dir")

end

---
-- Checks that the child file system entry template data objects can be returned as expected.
--
function TestDirectory:testCanReturnChildFileSystemEntryTemplateDataObjects()

  local directory = self:createFileSystemEntryInstance()

  self.fileSystemEntryCoverageDataMock.getSortedChildDirectoryCoverages = self.mach.mock_method(
    "getSortedChildDirectoryCoverages"
  )
  self.fileSystemEntryCoverageDataMock.getSortedChildFileCoverages = self.mach.mock_method(
    "getSortedChildFileCoverages"
  )

  local childDirectoryCoverageDataMocks = {
    self:getMock("luacov.html.CoverageData.FileSystemEntry", "ChildDirectoryCoverageDataMockA"),
    self:getMock("luacov.html.CoverageData.FileSystemEntry", "ChildDirectoryCoverageDataMockB"),
    self:getMock("luacov.html.CoverageData.FileSystemEntry", "ChildDirectoryCoverageDataMockC")
  }
  local childFileCoverageDataMocks = {
    self:getMock("luacov.html.CoverageData.FileSystemEntry", "ChildFileCoverageDataMockA"),
    self:getMock("luacov.html.CoverageData.FileSystemEntry", "ChildFileCoverageDataMockB"),
    self:getMock("luacov.html.CoverageData.FileSystemEntry", "ChildFileCoverageDataMockC")
  }

  local childDirectoryTemplateDataMocks = {
    self:getMock("luacov.html.Writer.TemplateData.FileSystemEntry", "ChildDirectoryTemplateDataMockA"),
    self:getMock("luacov.html.Writer.TemplateData.FileSystemEntry", "ChildDirectoryTemplateDataMockB"),
    self:getMock("luacov.html.Writer.TemplateData.FileSystemEntry", "ChildDirectoryTemplateDataMockC")
  }
  local childFileTemplateDataMocks = {
    self:getMock("luacov.html.Writer.TemplateData.FileSystemEntry", "ChildFileTemplateDataMockA"),
    self:getMock("luacov.html.Writer.TemplateData.FileSystemEntry", "ChildFileTemplateDataMockB"),
    self:getMock("luacov.html.Writer.TemplateData.FileSystemEntry", "ChildFileTemplateDataMockC")
  }

  local childFileSystemEntryTemplateDataObjects
  self.fileSystemEntryCoverageDataMock.getSortedChildDirectoryCoverages
                                      :should_be_called()
                                      :and_will_return(childDirectoryCoverageDataMocks)
                                      :and_then(
                                        self.templateDataFactoryMock.createDirectoryTemplateData
                                                                    :should_be_called_with(
                                                                      childDirectoryCoverageDataMocks[1]
                                                                    )
                                                                    :and_will_return(
                                                                      childDirectoryTemplateDataMocks[1]
                                                                    )
                                      )
                                      :and_also(
                                        self.templateDataFactoryMock.createDirectoryTemplateData
                                                                    :should_be_called_with(
                                                                      childDirectoryCoverageDataMocks[2]
                                                                    )
                                                                    :and_will_return(
                                                                      childDirectoryTemplateDataMocks[2]
                                                                    )
                                      )
                                      :and_also(
                                        self.templateDataFactoryMock.createDirectoryTemplateData
                                                                    :should_be_called_with(
                                                                      childDirectoryCoverageDataMocks[3]
                                                                    )
                                                                    :and_will_return(
                                                                      childDirectoryTemplateDataMocks[3]
                                                                    )
                                      )
                                      :and_also(
                                        self.fileSystemEntryCoverageDataMock.getSortedChildFileCoverages
                                            :should_be_called()
                                            :and_will_return(childFileCoverageDataMocks)
                                            :and_then(
                                              self.templateDataFactoryMock.createFileTemplateData
                                                  :should_be_called_with(childFileCoverageDataMocks[1])
                                                  :and_will_return(childFileTemplateDataMocks[1])
                                            )
                                            :and_also(
                                              self.templateDataFactoryMock.createFileTemplateData
                                                  :should_be_called_with(childFileCoverageDataMocks[2])
                                                  :and_will_return(childFileTemplateDataMocks[2])
                                            )
                                            :and_also(
                                              self.templateDataFactoryMock.createFileTemplateData
                                                  :should_be_called_with(childFileCoverageDataMocks[3])
                                                  :and_will_return(childFileTemplateDataMocks[3])
                                            )
                                      )
                                      :when(
                                        function()
                                          childFileSystemEntryTemplateDataObjects = directory:getChildFileSystemEntryTemplateDataObjects()
                                        end
                                      )

  local expectedChildFileSystemEntryTemplateDataObjects = {
    childDirectoryTemplateDataMocks[1],
    childDirectoryTemplateDataMocks[2],
    childDirectoryTemplateDataMocks[3],
    childFileTemplateDataMocks[1],
    childFileTemplateDataMocks[2],
    childFileTemplateDataMocks[3]
  }

  self:assertEquals(childFileSystemEntryTemplateDataObjects, expectedChildFileSystemEntryTemplateDataObjects)

end


---
-- Checks that the template values can be generated as expected.
--
function TestDirectory:testCanBeConvertedToTemplateValues()

  local directory = self:createFileSystemEntryInstance()

  local pathPartTemplateValues = {
    { baseName = "MyProject", relativePath = "../../" },
    { baseName = "source", relativePath = "../" }
  }

  local hitMissStatisticsTemplateValues = {
    numberOfHits = 187,
    numberOfMisses = 38,
    formattedHitPercentage = "83.11",
    hitPercentageStatusText = "high"
  }

  local childDirectoryTemplateValues = {
    {
      hitMissStatistics = {
        numberOfHits = 62,
        numberOfMisses = 10,
        formattedHitPercentage = "86.11",
        hitPercentageStatusText = "high"
      },
      relativePath = "Tasks/index.html",
      baseName = "Tasks"
    },
    {
      hitMissStatistics = {
        numberOfHits = 47,
        numberOfMisses = 5,
        formattedHitPercentage = "90.39",
        hitPercentageStatusText = "high"
      },
      relativePath = "Geometry/index.html",
      baseName = "Geometry"
    },
    {
      hitMissStatistics = {
        numberOfHits = 44,
        numberOfMisses = 11,
        formattedHitPercentage = "80.00",
        hitPercentageStatusText = "medium"
      },
      relativePath = "i18n/index.html",
      baseName = "i18n"
    }
  }

  local childFileTemplateValues = {
    {
      hitMissStatistics = {
        numberOfHits = 13,
        numberOfMisses = 0,
        formattedHitPercentage = "100.00",
        hitPercentageStatusText = "high"
      },
      relativePath = "./Configuration.html",
      baseName = "Configuration.lua"
    },
    {
      hitMissStatistics = {
        numberOfHits = 0,
        numberOfMisses = 7,
        formattedHitPercentage = "0",
        hitPercentageStatusText = "low"
      },
      relativePath = "./ExceptionHandler.html",
      baseName = "ExceptionHandler.lua"
    },
    {
      hitMissStatistics = {
        numberOfHits = 21,
        numberOfMisses = 5,
        formattedHitPercentage = "80.77",
        hitPercentageStatusText = "high"
      },
      relativePath = "./Dialog.html",
      baseName = "Dialog.lua"
    }
  }

  local templateValues
  self:expectRelativePathToRootCalculation(directory, "../../")
      :and_also(
        self:expectReportTargetNameFetching("MyProject/source/example-coverage-dir")
      )
      :and_also(
        self:expectPathPartTemplateValuesGeneration(directory, pathPartTemplateValues)
      )
      :and_also(
        self:expectBaseNameFetching("example-coverage-dir")
      )
      :and_also(
        self:expectHitMissStatisticsTemplateValueGeneration(hitMissStatisticsTemplateValues)
      )
      :and_also(
        self:expectChildFileSystemEntryTemplateValuesGeneration(
          directory,
          childDirectoryTemplateValues,
          childFileTemplateValues
        )
      )
      :when(
        function()
          templateValues = directory:toTemplateValues()
        end
      )

  local expectedTemplateValues = {
    relativePathToRoot = "../../",
    reportTarget = "MyProject/source/example-coverage-dir",

    pathParts = {
      { name = "MyProject", relativePath = "../../" },
      { name = "source", relativePath = "../" }
    },
    baseName = "example-coverage-dir",

    hitMissStatistics = {
      numberOfHits = 187,
      numberOfMisses = 38,
      formattedHitPercentage = "83.11",
      hitPercentageStatusText = "high"
    },

    fileSystemEntries = {
      {
        hitMissStatistics = {
          numberOfHits = 62,
          numberOfMisses = 10,
          formattedHitPercentage = "86.11",
          hitPercentageStatusText = "high"
        },
        relativePath = "Tasks/index.html",
        name = "Tasks"
      },
      {
        hitMissStatistics = {
          numberOfHits = 47,
          numberOfMisses = 5,
          formattedHitPercentage = "90.39",
          hitPercentageStatusText = "high"
        },
        relativePath = "Geometry/index.html",
        name = "Geometry"
      },
      {
        hitMissStatistics = {
          numberOfHits = 44,
          numberOfMisses = 11,
          formattedHitPercentage = "80.00",
          hitPercentageStatusText = "medium"
        },
        relativePath = "i18n/index.html",
        name = "i18n"
      },
      {
        hitMissStatistics = {
          numberOfHits = 13,
          numberOfMisses = 0,
          formattedHitPercentage = "100.00",
          hitPercentageStatusText = "high"
        },
        relativePath = "./Configuration.html",
        name = "Configuration.lua"
      },
      {
        hitMissStatistics = {
          numberOfHits = 0,
          numberOfMisses = 7,
          formattedHitPercentage = "0",
          hitPercentageStatusText = "low"
        },
        relativePath = "./ExceptionHandler.html",
        name = "ExceptionHandler.lua"
      },
      {
        hitMissStatistics = {
          numberOfHits = 21,
          numberOfMisses = 5,
          formattedHitPercentage = "80.77",
          hitPercentageStatusText = "high"
        },
        relativePath = "./Dialog.html",
        name = "Dialog.lua"
      }
    }
  }

  self:assertEquals(templateValues, expectedTemplateValues)

end


-- Private Methods

---
-- Returns the required expectations for the fetching of the report target name of the test Directory instance.
--
-- @tparam string _fullPath The full path to return
--
-- @treturn table The expectations
--
function TestDirectory:expectReportTargetNameFetching(_fullPath)

  return self.fileSystemEntryCoverageDataMock.calculateFullPath
                                             :should_be_called_with(true)
                                             :and_will_return(_fullPath)

end

---
-- Returns the expectations for the generation of the child file system entry template values.
--
-- The list of child file system entry template values to return must be in this format:
-- {
--   { hitMissStatistics = <table>, relativePath = <string>, baseName = <string> },
--   ...
-- }
--
-- @tparam TemplateData.Directory _directory The directory whose child file system entry template values are expected to be generated
-- @tparam table[] _childDirectoryTemplateValues The child directory template values to return
-- @tparam table[] _childFileTemplateValues The child file template values to return
--
-- @treturn table The expectations
--
function TestDirectory:expectChildFileSystemEntryTemplateValuesGeneration(_directory, _childDirectoryTemplateValues, _childFileTemplateValues)

  local coverageDataMockExpectation, templateDataMockExpectation, hitMissStatisticsTemplateDataMock

  -- Generate the child directory coverage expectations
  self.fileSystemEntryCoverageDataMock.getSortedChildDirectoryCoverages = self.mach.mock_method(
    "getSortedChildDirectoryCoverages"
  )

  local directoryCoverageMocks = {}
  local directoryCoverageMockExpectations, directoryTemplateDataMockExpectations
  local directoryCoverageMock, directoryTemplateDataMock

  for i = 1, #_childDirectoryTemplateValues, 1 do

    directoryCoverageMock = self:getMock(
      "luacov.html.CoverageData.FileSystemEntry", "ChildDirectoryCoverageDataMock_" .. i
    )
    directoryTemplateDataMock = self:getMock(
      "luacov.html.Writer.TemplateData.FileSystemEntry", "ChildDirectoryTemplateDataMock_" .. i
    )
    hitMissStatisticsTemplateDataMock = self:getMock(
      "luacov.html.Writer.TemplateData.HitMissStatistics", "DirectoryHitMissStatisticsTemplateDataMock_" .. i
    )

    coverageDataMockExpectation = self.templateDataFactoryMock.createDirectoryTemplateData
                                                              :should_be_called_with(directoryCoverageMock)
                                                              :and_will_return(directoryTemplateDataMock)


    templateDataMockExpectation = directoryTemplateDataMock.getHitMissStatistics
                                    :should_be_called()
                                    :and_will_return(hitMissStatisticsTemplateDataMock)
                                    :and_then(
                                      hitMissStatisticsTemplateDataMock.toTemplateValues
                                        :should_be_called()
                                        :and_will_return(
                                          _childDirectoryTemplateValues[i]["hitMissStatistics"]
                                        )
                                    )
                                    :and_also(
                                      directoryTemplateDataMock.getRelativePathFrom
                                        :should_be_called_with(_directory, true)
                                        :and_will_return(_childDirectoryTemplateValues[i]["relativePath"])
                                    )
                                    :and_also(
                                      directoryTemplateDataMock.getBaseName
                                        :should_be_called()
                                        :and_will_return(_childDirectoryTemplateValues[i]["baseName"])
                                    )

    if (i == 1) then
      directoryCoverageMockExpectations = coverageDataMockExpectation
      directoryTemplateDataMockExpectations = templateDataMockExpectation
    else
      directoryCoverageMockExpectations:and_also(coverageDataMockExpectation)
      directoryTemplateDataMockExpectations:and_also(templateDataMockExpectation)
    end

    directoryCoverageMocks[i] = directoryCoverageMock

  end


  -- Generate the child file coverage expectations
  self.fileSystemEntryCoverageDataMock.getSortedChildFileCoverages = self.mach.mock_method(
    "getSortedChildFileCoverages"
  )

  local fileCoverageMocks = {}
  local fileCoverageMockExpectations, fileTemplateDataMockExpectations
  local fileCoverageMock, fileTemplateDataMock

  for i = 1, #_childFileTemplateValues, 1 do

    fileCoverageMock = self:getMock(
      "luacov.html.CoverageData.FileSystemEntry", "ChildFileCoverageDataMock_" .. i
    )
    fileTemplateDataMock = self:getMock(
      "luacov.html.Writer.TemplateData.FileSystemEntry", "ChildFileTemplateDataMock_" .. i
    )
    hitMissStatisticsTemplateDataMock = self:getMock(
      "luacov.html.Writer.TemplateData.HitMissStatistics", "FileHitMissStatisticsTemplateDataMock_" .. i
    )

    coverageDataMockExpectation = self.templateDataFactoryMock.createFileTemplateData
                                                              :should_be_called_with(fileCoverageMock)
                                                              :and_will_return(fileTemplateDataMock)


    templateDataMockExpectation = fileTemplateDataMock.getHitMissStatistics
                                    :should_be_called()
                                    :and_will_return(hitMissStatisticsTemplateDataMock)
                                    :and_then(
                                      hitMissStatisticsTemplateDataMock.toTemplateValues
                                        :should_be_called()
                                        :and_will_return(_childFileTemplateValues[i]["hitMissStatistics"])
                                    )
                                    :and_also(
                                      fileTemplateDataMock.getRelativePathFrom
                                        :should_be_called_with(_directory, true)
                                        :and_will_return(_childFileTemplateValues[i]["relativePath"])
                                    )
                                    :and_also(
                                      fileTemplateDataMock.getBaseName
                                        :should_be_called()
                                        :and_will_return(_childFileTemplateValues[i]["baseName"])
                                    )

    if (i == 1) then
      fileCoverageMockExpectations = coverageDataMockExpectation
      fileTemplateDataMockExpectations = templateDataMockExpectation
    else
      fileCoverageMockExpectations:and_also(coverageDataMockExpectation)
      fileTemplateDataMockExpectations:and_also(templateDataMockExpectation)
    end

    fileCoverageMocks[i] = fileCoverageMock

  end


  return self.fileSystemEntryCoverageDataMock.getSortedChildDirectoryCoverages
             :should_be_called()
             :and_will_return(directoryCoverageMocks)
             :and_then(
               directoryCoverageMockExpectations
             )
             :and_also(
               self.fileSystemEntryCoverageDataMock.getSortedChildFileCoverages
                   :should_be_called()
                   :and_will_return(fileCoverageMocks)
                   :and_then(
                     fileCoverageMockExpectations
                   )
             )
             :and_then(
               directoryTemplateDataMockExpectations
             )
             :and_also(
               fileTemplateDataMockExpectations
             )

end


return TestDirectory
