---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local TestCase = require "wLuaUnit.TestCase"

---
-- Checks that the TemplateData.FileSystemEntry class works as expected.
--
-- @type FileSystemEntryTestBase
--
local FileSystemEntryTestBase = TestCase:extend()


---
-- The CoverageData.FileSystemEntry mock for the FileSystemEntry instances
--
-- @tfield table fileSystemEntryCoverageDataMock
--
FileSystemEntryTestBase.fileSystemEntryCoverageDataMock = nil

---
-- The root directory template data mock for the FileSystemEntry instances
--
-- @tfield table rootDirectoryTemplateDataMock
--
FileSystemEntryTestBase.rootDirectoryTemplateDataMock = nil

---
-- The OutputPathGenerator mock for the FileSystemEntry instances
--
-- @tfield table outputPathGeneratorMock
--
FileSystemEntryTestBase.outputPathGeneratorMock = nil

---
-- The TemplateDataFactory mock for the FileSystemEntry instances
--
-- @tfield table templateDataFactoryMock
--
FileSystemEntryTestBase.templateDataFactoryMock = nil


-- Public Methods

---
-- Method that is called before a test is executed.
-- Initializes the mocks.
--
function FileSystemEntryTestBase:setUp()

  TestCase.setUp(self)

  self.fileSystemEntryCoverageDataMock = self:getMock(
    "luacov.html.CoverageData.FileSystemEntry", "FileSystemEntryCoverageDataMock"
  )
  self.rootDirectoryTemplateDataMock = self:getMock(
    "luacov.html.Writer.TemplateData.FileSystemEntry", "RootDirectoryTemplateDataMock"
  )
  self.outputPathGeneratorMock = self:getMock(
    "luacov.html.Writer.Path.OutputPathGenerator", "OutputPathGeneratorMock"
  )
  self.templateDataFactoryMock = self:getMock(
    "luacov.html.Writer.TemplateData.TemplateDataFactory", "TemplateDataFactoryMock"
  )

end

---
-- Method that is called after a test was executed.
-- Clears the mocks.
--
function FileSystemEntryTestBase:tearDown()

  TestCase.tearDown(self)

  self.fileSystemEntryCoverageDataMock = nil
  self.rootDirectoryTemplateDataMock = nil
  self.outputPathGeneratorMock = nil
  self.templateDataFactoryMock = nil

end


---
-- Checks that a TemplateData.FileSystemEntry can return its base information.
-- Base information means data that is stored in the abstract TemplateData.FileSystemEntry class.
--
function FileSystemEntryTestBase:testCanReturnBaseInformation()

  local fileSystemEntry = self:createFileSystemEntryInstance()
  self:assertEquals(fileSystemEntry:getFileSystemEntryCoverageData(), self.fileSystemEntryCoverageDataMock)

end


---
-- Checks that the relative path to the root directory can be returned as expected.
--
function FileSystemEntryTestBase:testCanReturnRelativePathToRoot()

  local fileSystemEntry = self:createFileSystemEntryInstance()

  local relativePathToRoot
  self.rootDirectoryTemplateDataMock.getRelativePathFrom
                                    :should_be_called_with(fileSystemEntry, false)
                                    :and_will_return("../../")
                                    :when(
                                      function()
                                        relativePathToRoot = fileSystemEntry:getRelativePathToRoot()
                                      end
                                    )

  self:assertEquals(relativePathToRoot, "../../")

end

---
-- Checks that the relative path to another file system entry can be returned as expected when the
-- base name of the other file system entry should be excluded from the resulting path.
--
function FileSystemEntryTestBase:testCanReturnRelativePathFromOtherFileSystemEntryExcludingBasename()

  local fileSystemEntry = self:createFileSystemEntryInstance()
  local otherFileSystemEntryMock = self:getMock(
    "luacov.html.Writer.TemplateData.FileSystemEntry", "FileSystemEntryMock"
  )
  local otherFileSystemEntryCoverageDataMock = self:getMock(
    "luacov.html.CoverageData.FileSystemEntry", "FileSystemEntryCoverageDataMock"
  )

  local relativePath
  otherFileSystemEntryMock.getFileSystemEntryCoverageData
                          :should_be_called()
                          :and_will_return(otherFileSystemEntryCoverageDataMock)
                          :and_then(
                            self.outputPathGeneratorMock.generateRelativePath
                                                        :should_be_called_with(
                                                          otherFileSystemEntryCoverageDataMock,
                                                          self.fileSystemEntryCoverageDataMock,
                                                          false
                                                        )
                                                        :and_will_return("../test/")
                          )
                          :when(
                            function()
                              relativePath = fileSystemEntry:getRelativePathFrom(
                                otherFileSystemEntryMock, false
                              )
                            end
                          )

  self:assertEquals(relativePath, "../test/")

end

---
-- Checks that the relative path to another file system entry can be returned as expected when the
-- base name of the other file system entry should be included in the resulting path.
--
function FileSystemEntryTestBase:testCanReturnRelativePathFromOtherFileSystemEntryIncludingBasename()

  local fileSystemEntry = self:createFileSystemEntryInstance()
  local otherFileSystemEntryMock = self:getMock(
    "luacov.html.Writer.TemplateData.FileSystemEntry", "FileSystemEntryMock"
  )
  local otherFileSystemEntryCoverageDataMock = self:getMock(
    "luacov.html.CoverageData.FileSystemEntry", "FileSystemEntryCoverageDataMock"
  )

  local relativePath
  otherFileSystemEntryMock.getFileSystemEntryCoverageData
                          :should_be_called()
                          :and_will_return(otherFileSystemEntryCoverageDataMock)
                          :and_then(
                            self.outputPathGeneratorMock.generateRelativePath
                                                        :should_be_called_with(
                                                          otherFileSystemEntryCoverageDataMock,
                                                          self.fileSystemEntryCoverageDataMock,
                                                          true
                                                        )
                                                        :and_will_return("another/example/index.html")
                          )
                          :when(
                            function()
                              relativePath = fileSystemEntry:getRelativePathFrom(
                                otherFileSystemEntryMock, true
                              )
                            end
                          )

  self:assertEquals(relativePath, "another/example/index.html")

end


---
-- Checks that the report target name can be returned as expected.
-- This is an abstract method that must be implemented by inheriting TestCases.
--
function FileSystemEntryTestBase:testCanReturnReportTargetName()
  self:assertTrue(false, "Child TestCase should have implemented this test")
end


---
-- Checks that the path part TemplateData.Directory's can be returned as expected.
--
function FileSystemEntryTestBase:testCanReturnPathPartTemplateDataObjects()

  local fileSystemEntry = self:createFileSystemEntryInstance()

  local pathDirectoryCoverageMocks = {
    self:getMock("luacov.html.CoverageData.FileSystemEntry", "PathDirectoryCoverageMockA"),
    self:getMock("luacov.html.CoverageData.FileSystemEntry", "PathDirectoryCoverageMockB"),
    self:getMock("luacov.html.CoverageData.FileSystemEntry", "PathDirectoryCoverageMockC")
  }

  local pathDirectoryTemplateDataMocks = {
    self:getMock("luacov.html.Writer.TemplateData.FileSystemEntry", "PathDirectoryTemplateDataMockA"),
    self:getMock("luacov.html.Writer.TemplateData.FileSystemEntry", "PathDirectoryTemplateDataMockB"),
    self:getMock("luacov.html.Writer.TemplateData.FileSystemEntry", "PathDirectoryTemplateDataMockC")
  }

  local pathPartTemplateDataObjects
  self.fileSystemEntryCoverageDataMock.calculatePathDirectoryCoverages
                                      :should_be_called_with(true, false)
                                      :and_will_return(pathDirectoryCoverageMocks)
                                      :and_then(
                                        self.templateDataFactoryMock.createDirectoryTemplateData
                                                                    :should_be_called_with(
                                                                      pathDirectoryCoverageMocks[1]
                                                                    )
                                                                    :and_will_return(
                                                                      pathDirectoryTemplateDataMocks[1]
                                                                    )
                                      )
                                      :and_also(
                                        self.templateDataFactoryMock.createDirectoryTemplateData
                                                                    :should_be_called_with(
                                                                      pathDirectoryCoverageMocks[2]
                                                                    )
                                                                    :and_will_return(
                                                                      pathDirectoryTemplateDataMocks[2]
                                                                    )
                                      )
                                      :and_also(
                                        self.templateDataFactoryMock.createDirectoryTemplateData
                                                                    :should_be_called_with(
                                                                      pathDirectoryCoverageMocks[3]
                                                                    )
                                                                    :and_will_return(
                                                                      pathDirectoryTemplateDataMocks[3]
                                                                    )
                                      )
                                      :when(
                                        function()
                                          pathPartTemplateDataObjects = fileSystemEntry:getPathPartTemplateDataObjects()
                                        end
                                      )

  self:assertEquals(#pathPartTemplateDataObjects, 3)
  self:assertEquals(pathPartTemplateDataObjects[1], pathDirectoryTemplateDataMocks[1])
  self:assertEquals(pathPartTemplateDataObjects[2], pathDirectoryTemplateDataMocks[2])
  self:assertEquals(pathPartTemplateDataObjects[3], pathDirectoryTemplateDataMocks[3])

end

---
-- Checks that the base name can be returned as expected.
--
function FileSystemEntryTestBase:testCanReturnBaseName()

  local fileSystemEntry = self:createFileSystemEntryInstance()

  local baseName
  self.fileSystemEntryCoverageDataMock.getBaseName
                                      :should_be_called()
                                      :and_will_return("its_a_test.lua")
                                      :when(
                                        function()
                                          baseName = fileSystemEntry:getBaseName()
                                        end
                                      )

  self:assertEquals(baseName, "its_a_test.lua")

end

---
-- Checks that the hit/miss statistics can be returned as expected.
--
function FileSystemEntryTestBase:testCanReturnHitMissStatistics()

  local fileSystemEntry = self:createFileSystemEntryInstance()

  local hitMissStatisticsCoverageDataMock = self:getMock(
    "luacov.html.CoverageData.Util.HitMissStatistics", "HitMissStatisticsCoverageDataMock"
  )
  local hitMissStatisticsMock = self:getMock(
    "luacov.html.Writer.TemplateData.HitMissStatistics", "HitMissStatisticsMock"
  )

  local hitMissStatistics
  self.fileSystemEntryCoverageDataMock.getHitMissStatistics
                                      :should_be_called()
                                      :and_will_return(hitMissStatisticsCoverageDataMock)
                                      :and_then(
                                        self.templateDataFactoryMock.createHitMissStatisticsTemplateData
                                                                    :should_be_called_with(
                                                                      hitMissStatisticsCoverageDataMock
                                                                    )
                                                                    :and_will_return(hitMissStatisticsMock)
                                      )
                                      :when(
                                        function()
                                          hitMissStatistics = fileSystemEntry:getHitMissStatistics()
                                        end
                                      )

  self:assertEquals(hitMissStatistics, hitMissStatisticsMock)

end


---
-- Checks that the template values can be generated as expected.
-- This is an abstract method that must be implemented by inheriting TestCases.
--
function FileSystemEntryTestBase:testCanBeConvertedToTemplateValues()
  self:assertTrue(false, "Child TestCase should have implemented this test")
end


-- Protected Methods

---
-- Creates and returns an instance of the test class.
--
-- @treturn TemplateData.FileSystemEntry The created instance of the test class
--
function FileSystemEntryTestBase:createFileSystemEntryInstance()

  local FileSystemEntry = self.testClass

  return FileSystemEntry(
    self.fileSystemEntryCoverageDataMock,
    self.rootDirectoryTemplateDataMock,
    self.outputPathGeneratorMock,
    self.templateDataFactoryMock
  )

end


---
-- Returns the required expectations for the calculation of the relative path to the root directory of the
-- test FileSystemEntry instance.
--
-- @tparam TemplateData.FileSystemEntry _fileSystemEntry The file system entry whose relative path to the root directory is expected to be calculated
-- @tparam string _relativePathToRoot The relative path to the root directory to return
--
-- @treturn table The expectations
--
function FileSystemEntryTestBase:expectRelativePathToRootCalculation(_fileSystemEntry, _relativePathToRoot)

  return self.rootDirectoryTemplateDataMock.getRelativePathFrom
                                           :should_be_called_with(_fileSystemEntry, false)
                                           :and_will_return(_relativePathToRoot)

end

---
-- Returns the expectations for the generation of the path part template values.
--
-- The list of path part template values to return must be in this format:
-- {
--   { baseName = <string>, relativePath = <string> },
--   ...
-- }
--
-- @tparam TemplateData.FileSystemEntry _fileSystemEntry The file system entry whose path part template values are expected to be generated
-- @tparam table[] _pathPartTemplateValues The path part template values to return
--
-- @treturn table The expectations
--
function FileSystemEntryTestBase:expectPathPartTemplateValuesGeneration(_fileSystemEntry, _pathPartTemplateValues)

  -- Generate path directory coverage mocks and path directory template data mocks
  local pathDirectoryCoverageMocks = {}
  local pathDirectoryCoverageMockExpectations, pathDirectoryTemplateDataMockExpectations
  local directoryCoverageMock, directoryTemplateDataMock, coverageDataMockExpectation, templateDataMockExpectation
  for i = 1, #_pathPartTemplateValues, 1 do

    directoryCoverageMock = self:getMock(
      "luacov.html.CoverageData.FileSystemEntry", "PathDirectoryCoverageMock_" .. i
    )
    directoryTemplateDataMock = self:getMock(
      "luacov.html.Writer.TemplateData.FileSystemEntry", "PathDirectoryTemplateDataMock_" .. i
    )

    coverageDataMockExpectation = self.templateDataFactoryMock.createDirectoryTemplateData
                                                                       :should_be_called_with(
                                                                         directoryCoverageMock
                                                                       )
                                                                       :and_will_return(
                                                                         directoryTemplateDataMock
                                                                       )

    templateDataMockExpectation = directoryTemplateDataMock.getBaseName
                                                           :should_be_called()
                                                           :and_will_return(
                                                             _pathPartTemplateValues[i]["baseName"]
                                                           )
                                                           :and_also(
                                                             directoryTemplateDataMock.getRelativePathFrom
                                                                                      :should_be_called_with(
                                                                                        _fileSystemEntry,
                                                                                        true
                                                                                      )
                                                                                      :and_will_return(
                                                                                        _pathPartTemplateValues[i]["relativePath"]
                                                                                      )
                                                           )

    if (i == 1) then
      pathDirectoryCoverageMockExpectations = coverageDataMockExpectation
      pathDirectoryTemplateDataMockExpectations = templateDataMockExpectation
    else
      pathDirectoryCoverageMockExpectations:and_also(coverageDataMockExpectation)
      pathDirectoryTemplateDataMockExpectations:and_also(templateDataMockExpectation)
    end

    pathDirectoryCoverageMocks[i] = directoryCoverageMock

  end


  local expectations = self.fileSystemEntryCoverageDataMock.calculatePathDirectoryCoverages
                                                           :should_be_called_with(true, false)
                                                           :and_will_return(pathDirectoryCoverageMocks)

  if (pathDirectoryCoverageMockExpectations) then
    expectations:and_then(pathDirectoryCoverageMockExpectations)
  end

  if (pathDirectoryTemplateDataMockExpectations) then
    expectations:and_then(pathDirectoryTemplateDataMockExpectations)
  end

  return expectations

end

---
-- Returns the required expectations for the fetching of the base name of the test FileSystemEntry instance.
--
-- @tparam string _baseName The base name to return
--
-- @treturn table The expectations
--
function FileSystemEntryTestBase:expectBaseNameFetching(_baseName)

  return self.fileSystemEntryCoverageDataMock.getBaseName
                                             :should_be_called()
                                             :and_will_return(_baseName)

end

---
-- Returns the required expectations for the HitMissStatistics template values generation of
-- the test FileSystemEntry instance.
--
-- @tparam table _hitMissStatisticsTemplateValues The HitMissStatistics template values to return
--
-- @treturn table The expectations
--
function FileSystemEntryTestBase:expectHitMissStatisticsTemplateValueGeneration(_hitMissStatisticsTemplateValues)

  local hitMissStatisticsCoverageDataMock = self:getMock(
    "luacov.html.CoverageData.Util.HitMissStatistics", "HitMissStatisticsCoverageDataMock"
  )
  local hitMissStatisticsMock = self:getMock(
    "luacov.html.Writer.TemplateData.HitMissStatistics", "HitMissStatisticsMock"
  )

  return self.fileSystemEntryCoverageDataMock.getHitMissStatistics
                                             :should_be_called()
                                             :and_will_return(hitMissStatisticsCoverageDataMock)
                                             :and_then(
                                               self.templateDataFactoryMock.createHitMissStatisticsTemplateData
                                                                           :should_be_called_with(
                                                                             hitMissStatisticsCoverageDataMock
                                                                           )
                                                                           :and_will_return(
                                                                             hitMissStatisticsMock
                                                                           )
                                             )
                                             :and_then(
                                               hitMissStatisticsMock.toTemplateValues
                                                                    :should_be_called()
                                                                    :and_will_return(
                                                                      _hitMissStatisticsTemplateValues
                                                                    )
                                             )

end


return FileSystemEntryTestBase
