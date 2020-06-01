---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local TestCase = require "wLuaUnit.TestCase"

---
-- Checks that the CoverageData.Total class works as expected.
--
-- @type TestTotal
--
local TestTotal = TestCase:extend()


---
-- The require path for the class that is tested by this TestCase
--
-- @tfield string testClassPath
--
TestTotal.testClassPath = "luacov.html.CoverageData.Total"

---
-- The paths of the classes that the test class depends on
--
-- @tfield table[] dependencyPaths
--
TestTotal.dependencyPaths = {
  { id = "Directory", path = "luacov.html.CoverageData.Directory" },
  { id = "FilePathNormalizer", path = "luacov.html.CoverageData.Util.FilePathNormalizer" }
}

---
-- The mock for the CoverageData.Directory of the root directory
--
-- @tfield table rootDirectoryCoverageDataMock
--
TestTotal.rootDirectoryCoverageDataMock = nil

---
-- The FilePathNormalizer mock
--
-- @tfield table filePathNormalizerMock
--
TestTotal.filePathNormalizerMock = nil


-- Public Methods

---
-- Method that is called before a test is executed.
-- Initializes the mocks.
--
function TestTotal:setUp()
  TestCase.setUp(self)
  self.rootDirectoryCoverageDataMock = self:getMock("luacov.html.CoverageData.Directory", "RootDirectoryMock")
  self.filePathNormalizerMock = self:getMock("luacov.html.CoverageData.Util.FilePathNormalizer", "FilePathNormalizerMock")
end

---
-- Method that is called after a test was executed.
-- Clears the mocks.
--
function TestTotal:tearDown()
  TestCase.tearDown(self)
  self.rootDirectoryCoverageDataMock = nil
  self.FilePathNormalizerMock = nil
end


---
-- Checks that the getters and setters work as expected.
--
function TestTotal:testCanGetAndSetValues()

  local Total = self.testClass

  local totalCoverage
  self:expectTotalCoverageDataInitialization("proj")
      :when(
        function()
          totalCoverage = Total("proj")
        end
      )

  self:assertEquals(totalCoverage:getRootDirectoryCoverageData(), self.rootDirectoryCoverageDataMock)
  self:assertNil(totalCoverage:getStartTimestamp())

  local now = os.time()
  totalCoverage:setStartTimestamp(now)
  self:assertEquals(totalCoverage:getStartTimestamp(), now)

end


---
-- Checks that an empty line can be added to the CoverageData.Total as expected.
--
function TestTotal:testCanAddEmptyLine()

  local Total = self.testClass

  local totalCoverage
  self:expectTotalCoverageDataInitialization("another")
      :when(
        function()
          totalCoverage = Total("another")
        end
      )

  local fileCoverageDataMock = self:getMock("luacov.html.CoverageData.File", "FileCoverageDataMock")

  self.filePathNormalizerMock.normalizeFilePath
                             :should_be_called_with("../a/example/file/path.lua")
                             :and_will_return("a/example/file/path.lua")
                             :and_then(
                               self.rootDirectoryCoverageDataMock.getOrCreateFileCoverageData
                                                                 :should_be_called_with(
                                                                   "a/example/file/path.lua"
                                                                 )
                                                                 :and_will_return(fileCoverageDataMock)
                             )
                             :and_then(
                               fileCoverageDataMock.addEmptyLine
                                                   :should_be_called_with(1, "---")
                             )
                             :when(
                               function()
                                 totalCoverage:addEmptyLine("../a/example/file/path.lua", 1, "---")
                               end
                             )

end

---
-- Checks that a missed line can be added to the CoverageData.Total as expected.
--
function TestTotal:testCanAddMissedLine()

  local Total = self.testClass

  local totalCoverage
  self:expectTotalCoverageDataInitialization("hello")
      :when(
        function()
          totalCoverage = Total("hello")
        end
      )

  local fileCoverageDataMock = self:getMock("luacov.html.CoverageData.File", "FileCoverageDataMock")

  self.filePathNormalizerMock.normalizeFilePath
                             :should_be_called_with("./just/another/example.lua")
                             :and_will_return("just/another/example.lua")
                             :and_then(
                               self.rootDirectoryCoverageDataMock.getOrCreateFileCoverageData
                                                                 :should_be_called_with(
                                                                   "just/another/example.lua"
                                                                 )
                                                                 :and_will_return(fileCoverageDataMock)
                             )
                             :and_then(
                               fileCoverageDataMock.addMissedLine
                                                   :should_be_called_with(5, "  printFile(file)")
                             )
                             :when(
                               function()
                                 totalCoverage:addMissedLine(
                                   "./just/another/example.lua", 5, "  printFile(file)"
                                 )
                               end
                             )

end

---
-- Checks that a hit line can be added to the CoverageData.Total as expected.
--
function TestTotal:testCanAddHitLine()

  local Total = self.testClass

  local totalCoverage
  self:expectTotalCoverageDataInitialization("test")
      :when(
        function()
          totalCoverage = Total("test")
        end
      )

  local fileCoverageDataMock = self:getMock("luacov.html.CoverageData.File", "FileCoverageDataMock")

  self.filePathNormalizerMock.normalizeFilePath
                             :should_be_called_with("../../final-example.lua")
                             :and_will_return("final-example.lua")
                             :and_then(
                               self.rootDirectoryCoverageDataMock.getOrCreateFileCoverageData
                                                                 :should_be_called_with("final-example.lua")
                                                                 :and_will_return(fileCoverageDataMock)
                             )
                             :and_then(
                               fileCoverageDataMock.addHitLine
                                                   :should_be_called_with(333, "  return true", 14)
                             )
                             :when(
                               function()
                                 totalCoverage:addHitLine(
                                   "../../final-example.lua", 333, "  return true", 14
                                 )
                               end
                             )

end


---
-- Checks that hit/miss statistics can be added to the Coverage.Total as expected.
--
function TestTotal:testCanAddFileHitMissStatistics()

  local Total = self.testClass

  local totalCoverage
  self:expectTotalCoverageDataInitialization("All Files")
      :when(
        function()
          totalCoverage = Total("All Files")
        end
      )

  local fileCoverageDataMock = self:getMock("luacov.html.CoverageData.FileSystemEntry", "FileCoverageDataMock")

  self.filePathNormalizerMock.normalizeFilePath
                             :should_be_called_with(".././done.lua")
                             :and_will_return("done.lua")
                             :and_then(
                               self.rootDirectoryCoverageDataMock.getOrCreateFileCoverageData
                                                                 :should_be_called_with("done.lua")
                                                                 :and_will_return(fileCoverageDataMock)
                             )
                             :and_then(
                               fileCoverageDataMock.addHitMissStatistics
                                                   :should_be_called_with(123, 456)
                             )
                             :when(
                               function()
                                 totalCoverage:addFileHitMissStatistics(".././done.lua", 123, 456)
                               end
                             )

end


---
-- Checks that the last fetched CoverageData.File is cached as expected.
--
function TestTotal:testDoesCacheLastFetchedFileCoverageData()

  local Total = self.testClass

  local totalCoverage
  self:expectTotalCoverageDataInitialization("Files")
      :when(
        function()
          totalCoverage = Total("Files")
        end
      )

  local fileCoverageDataMockA = self:getMock("luacov.html.CoverageData.File", "FileCoverageDataMockA")
  local fileCoverageDataMockB = self:getMock("luacov.html.CoverageData.File", "FileCoverageDataMockB")
  local fileCoverageDataMockC = self:getMock("luacov.html.CoverageData.File", "FileCoverageDataMockC")

  self.filePathNormalizerMock.normalizeFilePath
                             :should_be_called_with("../first.lua")
                             :and_will_return("first.lua")
                             :and_then(
                               self.rootDirectoryCoverageDataMock.getOrCreateFileCoverageData
                                                                 :should_be_called_with("first.lua")
                                                                 :and_will_return(fileCoverageDataMockA)
                             )
                             :and_then(
                               fileCoverageDataMockA.addEmptyLine
                                                    :should_be_called_with(1, "---")
                             )
                             :and_then(
                               fileCoverageDataMockA.addEmptyLine
                                                    :should_be_called_with(2, "-- This is a comment")
                             )
                             :and_then(
                               fileCoverageDataMockA.addEmptyLine
                                                    :should_be_called_with(3, "-- With multiple lines")
                             )
                             :and_then(
                               fileCoverageDataMockA.addEmptyLine
                                                    :should_be_called_with(4, "--")
                             )

                             :and_then(
                               self.filePathNormalizerMock.normalizeFilePath
                                                          :should_be_called_with("./second.lua")
                                                          :and_will_return("second.lua")
                             )
                             :and_then(
                               self.rootDirectoryCoverageDataMock.getOrCreateFileCoverageData
                                                                 :should_be_called_with("second.lua")
                                                                 :and_will_return(fileCoverageDataMockB)
                             )
                             :and_then(
                               fileCoverageDataMockB.addEmptyLine
                                                    :should_be_called_with(1, "---")
                             )
                             :and_then(
                               fileCoverageDataMockB.addEmptyLine
                                                    :should_be_called_with(2, "-- Other file, but")
                             )
                             :and_then(
                               fileCoverageDataMockB.addEmptyLine
                                                    :should_be_called_with(
                                                      3, "-- it also starts with a multi line comment"
                                                    )
                             )
                             :and_then(
                               fileCoverageDataMockB.addEmptyLine
                                                    :should_be_called_with(4, "--")
                             )

                             :and_then(
                               self.filePathNormalizerMock.normalizeFilePath
                                                          :should_be_called_with("./../third.lua")
                                                          :and_will_return("third.lua")
                             )
                             :and_then(
                               self.rootDirectoryCoverageDataMock.getOrCreateFileCoverageData
                                                                 :should_be_called_with("third.lua")
                                                                 :and_will_return(fileCoverageDataMockC)
                             )
                             :and_then(
                               fileCoverageDataMockC.addMissedLine
                                                    :should_be_called_with(1, "return false")
                             )
                             :and_then(
                               fileCoverageDataMockC.addEmptyLine
                                                    :should_be_called_with(2, "")
                             )

                             :when(
                               function()
                                 totalCoverage:addEmptyLine("../first.lua", 1, "---")
                                 totalCoverage:addEmptyLine("../first.lua", 2, "-- This is a comment")
                                 totalCoverage:addEmptyLine("../first.lua", 3, "-- With multiple lines")
                                 totalCoverage:addEmptyLine("../first.lua", 4, "--")

                                 totalCoverage:addEmptyLine("./second.lua", 1, "---")
                                 totalCoverage:addEmptyLine("./second.lua", 2, "-- Other file, but")
                                 totalCoverage:addEmptyLine(
                                   "./second.lua", 3, "-- it also starts with a multi line comment"
                                 )
                                 totalCoverage:addEmptyLine("./second.lua", 4, "--")

                                 totalCoverage:addMissedLine("./../third.lua", 1, "return false")
                                 totalCoverage:addEmptyLine("./../third.lua", 2, "")
                               end
                             )

end


-- Private Methods

---
-- Returns the required expectations for a CoverageData.Total's creation.
--
-- @tparam string _rootDirectoryName The expected root directory name
--
-- @treturn table The expectations
--
function TestTotal:expectTotalCoverageDataInitialization(_rootDirectoryName)

  return self:expectRootDirectoryCoverageDataCreation(_rootDirectoryName)
             :and_also(
               self:expectFilePathNormalizerCreation()
             )

end

---
-- Returns the required expectations for a CoverageData.Total's root Coverage.Directory creation.
-- Also injects the rootDirectoryCoverageMock via the expectations return values.
--
-- @tparam string _directoryName The expected directory name
--
-- @treturn table The expectations
--
function TestTotal:expectRootDirectoryCoverageDataCreation(_directoryName)

  return self.dependencyMocks.Directory.__call
                                       :should_be_called_with(_directoryName, nil)
                                       :and_will_return(self.rootDirectoryCoverageDataMock)

end

---
-- Returns the required expectations for a CoverageData.Total's FilePathNormalizer creation.
-- Also injects the filePathNormalizerMock via the expectations return values.
--
-- @treturn table The expectations
--
function TestTotal:expectFilePathNormalizerCreation()

  return self.dependencyMocks.FilePathNormalizer.__call
                                                :should_be_called()
                                                :and_will_return(self.filePathNormalizerMock)

end


return TestTotal
