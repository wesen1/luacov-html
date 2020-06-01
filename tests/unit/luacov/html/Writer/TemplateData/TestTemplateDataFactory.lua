---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local TestCase = require "wLuaUnit.TestCase"

---
-- Checks that the TemplateDataFactory class works as expected.
--
-- @type TestTemplateDataFactory
--
local TestTemplateDataFactory = TestCase:extend()


---
-- The require path for the class that is tested by this TestCase
--
-- @tfield string testClassPath
--
TestTemplateDataFactory.testClassPath = "luacov.html.Writer.TemplateData.TemplateDataFactory"

---
-- The paths of the classes that the test class depends on
--
-- @tfield table[] dependencyPaths
--
TestTemplateDataFactory.dependencyPaths = {
  { id = "Directory", path = "luacov.html.Writer.TemplateData.Directory" },
  { id = "File", path = "luacov.html.Writer.TemplateData.File" },
  { id = "HitMissStatistics", path = "luacov.html.Writer.TemplateData.HitMissStatistics" },
  { id = "Line", path = "luacov.html.Writer.TemplateData.Line" },
  { id = "Total", path = "luacov.html.Writer.TemplateData.Total" }
}


---
-- The OutputPathGenerator mock for the test TemplateDataFactory instances
--
-- @tfield table outputPathGeneratorMock
--
TestTemplateDataFactory.outputPathGeneratorMock = nil

---
-- The root directory TemplateData.Directory mock for the test TemplateDataFactory instances
--
-- @tfield table rootDirectoryTemplateDataMock
--
TestTemplateDataFactory.rootDirectoryTemplateDataMock = nil


-- Public Methods

---
-- Method that is called before a test is executed.
-- Initializes the mocks.
--
function TestTemplateDataFactory:setUp()
  TestCase.setUp(self)

  self.outputPathGeneratorMock = self:getMock(
    "luacov.html.Writer.Path.OutputPathGenerator", "OutputPathGeneratorMock"
  )
  self.rootDirectoryTemplateDataMock = self:getMock(
    "luacov.html.Writer.TemplateData.Directory", "RootDirectoryTemplateDataMock"
  )
end

---
-- Method that is called after a test was executed.
-- Clears the mocks.
--
function TestTemplateDataFactory:tearDown()
  TestCase.tearDown(self)

  self.outputPathGeneratorMock = nil
  self.rootDirectoryTemplateDataMock = nil
end


---
-- Checks that a TemplateData.Directory instance can be created as expected.
--
function TestTemplateDataFactory:testCanCreateDirectoryTemplateData()

  local templateDataFactory = self:createTemplateDataFactoryInstance()
  local directoryCoverageDataMock = self:getMock(
    "luacov.html.CoverageData.Directory", "DirectoryCoverageDataMock"
  )
  local directoryTemplateDataMock = self:getMock(
    "luacov.html.Writer.TemplateData.Directory", "DirectoryTemplateDataMock"
  )

  local directoryTemplateData
  self.dependencyMocks.Directory.__call
                                :should_be_called_with(
                                  directoryCoverageDataMock,
                                  self.rootDirectoryTemplateDataMock,
                                  self.outputPathGeneratorMock,
                                  templateDataFactory
                                )
                                :and_will_return(directoryTemplateDataMock)
                                :when(
                                  function()
                                    directoryTemplateData = templateDataFactory:createDirectoryTemplateData(
                                      directoryCoverageDataMock
                                    )
                                  end
                                )

  self:assertIs(directoryTemplateData, directoryTemplateDataMock)

end

---
-- Checks that a TemplateData.File instance can be created as expected.
--
function TestTemplateDataFactory:testCanCreateFileTemplateData()

  local templateDataFactory = self:createTemplateDataFactoryInstance()
  local fileCoverageDataMock = self:getMock(
    "luacov.html.CoverageData.File", "FileCoverageDataMock"
  )
  local fileTemplateDataMock = self:getMock(
    "luacov.html.Writer.TemplateData.File", "FileTemplateDataMock"
  )

  local fileTemplateData
  self.dependencyMocks.File.__call
                           :should_be_called_with(
                             fileCoverageDataMock,
                             self.rootDirectoryTemplateDataMock,
                             self.outputPathGeneratorMock,
                             templateDataFactory
                           )
                           :and_will_return(fileTemplateDataMock)
                           :when(
                             function()
                               fileTemplateData = templateDataFactory:createFileTemplateData(
                                 fileCoverageDataMock
                               )
                             end
                           )

  self:assertIs(fileTemplateData, fileTemplateDataMock)

end

---
-- Checks that a TemplateData.Total instance can be created as expected.
--
function TestTemplateDataFactory:testCanCreateTotalTemplateData()

  local templateDataFactory = self:createTemplateDataFactoryInstance()
  local totalCoverageDataMock = self:getMock(
    "luacov.html.CoverageData.Total", "TotalCoverageDataMock"
  )
  local totalTemplateDataMock = self:getMock(
    "luacov.html.Writer.TemplateData.Total", "TotalTemplateDataMock"
  )

  local totalTemplateData
  self.dependencyMocks.Total.__call
                            :should_be_called_with(totalCoverageDataMock)
                            :and_will_return(totalTemplateDataMock)
                            :when(
                              function()
                                totalTemplateData = templateDataFactory:createTotalTemplateData(
                                  totalCoverageDataMock
                                )
                              end
                            )

  self:assertIs(totalTemplateData, totalTemplateDataMock)

end

---
-- Checks that a TemplateData.HitMissStatistics instance can be created as expected.
--
function TestTemplateDataFactory:testCanCreateHitMissStatisticsTemplateData()

  local templateDataFactory = self:createTemplateDataFactoryInstance()
  local hitMissStatisticsCoverageDataMock = self:getMock(
    "luacov.html.CoverageData.Util.HitMissStatistics", "HitMissStatisticsCoverageDataMock"
  )
  local hitMissStatisticsTemplateDataMock = self:getMock(
    "luacov.html.Writer.TemplateData.HitMissStatistics", "HitMissStatisticsTemplateDataMock"
  )

  local hitMissStatisticsTemplateData
  self.dependencyMocks.HitMissStatistics.__call
      :should_be_called_with(hitMissStatisticsCoverageDataMock)
      :and_will_return(hitMissStatisticsTemplateDataMock)
      :when(
        function()
          hitMissStatisticsTemplateData = templateDataFactory:createHitMissStatisticsTemplateData(
            hitMissStatisticsCoverageDataMock
          )
        end
      )

  self:assertIs(hitMissStatisticsTemplateData, hitMissStatisticsTemplateDataMock)

end

---
-- Checks that a TemplateData.Line instance can be created as expected.
--
function TestTemplateDataFactory:testCanCreateLineTemplateData()

  local templateDataFactory = self:createTemplateDataFactoryInstance()
  local lineCoverageDataMock = self:getMock(
    "luacov.html.CoverageData.Line", "LineCoverageDataMock"
  )
  local lineTemplateDataMock = self:getMock(
    "luacov.html.Writer.TemplateData.Line", "LineTemplateDataMock"
  )

  local lineTemplateData
  self.dependencyMocks.Line.__call
                           :should_be_called_with(lineCoverageDataMock)
                           :and_will_return(lineTemplateDataMock)
                           :when(
                             function()
                               lineTemplateData = templateDataFactory:createLineTemplateData(
                                 lineCoverageDataMock
                               )
                             end
                           )

  self:assertIs(lineTemplateData, lineTemplateDataMock)

end


-- Private Methods

---
-- Creates and returns a TemplateDataFactory instance.
-- Also injects the outputPathGeneratorMock and the rootDirectoryTemplateDataMock into the instance.
--
-- @treturn TemplateDataFactory The created TemplateDataFactory instance
--
function TestTemplateDataFactory:createTemplateDataFactoryInstance()

  local TemplateDataFactory = self.testClass

  local templateDataFactory = TemplateDataFactory(self.outputPathGeneratorMock)

  local rootDirectoryCoverageDataMock = self:getMock(
    "luacov.html.CoverageData.Directory", "RootDirectoryCoverageDataMock"
  )
  self.dependencyMocks.Directory.__call
                                :should_be_called_with(
                                  rootDirectoryCoverageDataMock,
                                  nil,
                                  self.outputPathGeneratorMock,
                                  templateDataFactory
                                )
                                :and_will_return(self.rootDirectoryTemplateDataMock)
                                :when(
                                  function()
                                    templateDataFactory:setRootDirectory(rootDirectoryCoverageDataMock)
                                  end
                                )

  return templateDataFactory

end


return TestTemplateDataFactory
