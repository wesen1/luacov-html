---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local FileSystemEntryTestBase = require "tests.unit.luacov.html.CoverageData.FileSystemEntryTestBase"

---
-- Checks that the CoverageData.Directory class works as expected.
--
-- @type TestDirectory
--
local TestDirectory = FileSystemEntryTestBase:extend()


---
-- The require path for the class that is tested by this TestCase
--
-- @tfield string testClassPath
--
TestDirectory.testClassPath = "luacov.html.CoverageData.Directory"

---
-- The paths of the classes that the test class depends on
--
-- @tfield table[] dependencyPaths
--
TestDirectory.dependencyPaths = {
  { id = "HitMissStatistics", path = "luacov.html.CoverageData.Util.HitMissStatistics" },
  { id = "File", path = "luacov.html.CoverageData.File" },
  { id = "FileSystemEntryCollection", path = "luacov.html.CoverageData.Util.FileSystemEntryCollection" }
}

---
-- The FileSystemEntryCollection mock for the child CoverageData.Directory's of the test CoverageData.Directory's
--
-- @tfield table directoryCoverageDataCollectionMock
--
TestDirectory.directoryCoverageDataCollectionMock = nil

---
-- The FileSystemEntryCollection mock for the child CoverageData.File's of the test CoverageData.Directory's
--
-- @tfield table directoryCoverageDataCollectionMock
--
TestDirectory.fileCoverageDataCollectionMock = nil


-- Public Methods

---
-- Method that is called before a test is executed.
-- Initializes the mocks.
--
function TestDirectory:setUp()
  FileSystemEntryTestBase.setUp(self)

  self.directoryCoverageDataCollectionMock = self:getMock(
    "luacov.html.CoverageData.Util.FileSystemEntryCollection", "DirectoryCoverageDataCollectionMock"
  )
  self.fileCoverageDataCollectionMock = self:getMock(
    "luacov.html.CoverageData.Util.FileSystemEntryCollection", "FileCoverageDataCollectionMock"
  )
end

---
-- Method that is called after a test was executed.
-- Clears the mocks.
--
function TestDirectory:tearDown()
  FileSystemEntryTestBase.tearDown(self)

  self.directoryCoverageDataCollectionMock = nil
  self.fileCoverageDataCollectionMock = nil
end


---
-- Checks that a CoverageData.Directory can create and return CoverageData.File's for a direct child file.
--
function TestDirectory:testCanGetOrCreateCoverageDataForDirectChildFile()

  local Directory = self.testClass

  local coverageData

  local directory
  self:expectDirectoryInitialization()
      :when(
        function()
          directory = Directory("testdir", self.parentDirectoryCoverageDataMock)
        end
      )

  local fileCoverageDataMock = self:getMock("luacov.html.CoverageData.File")
  self.fileCoverageDataCollectionMock.getOrCreateCoverageData
      :should_be_called_with("directchild")
      :and_will_return(fileCoverageDataMock)
      :when(
        function()
          coverageData = directory:getOrCreateFileCoverageData("directchild")
        end
      )

  self:assertIs(coverageData, fileCoverageDataMock)

end

---
-- Checks that a CoverageData.Directory can create and return CoverageData.File's for an indirect child file.
--
function TestDirectory:testCanGetOrCreateCoverageDataForIndirectChildFile()

  local Directory = self.testClass

  local coverageData

  local directory
  self:expectDirectoryInitialization()
      :when(
        function()
          directory = Directory("testdir", self.parentDirectoryCoverageDataMock)
        end
      )

  local directoryCoverageDataMock = self:getMock("luacov.html.CoverageData.Directory")
  local fileCoverageDataMock = self:getMock("luacov.html.CoverageData.File")

  self.directoryCoverageDataCollectionMock.getOrCreateCoverageData
      :should_be_called_with("this")
      :and_will_return(directoryCoverageDataMock)
      :and_then(
        directoryCoverageDataMock.getOrCreateFileCoverageData
                                 :should_be_called_with("is/not/a/direct/child.lua")
                                 :and_will_return(fileCoverageDataMock)
      )
      :when(
        function()
          coverageData = directory:getOrCreateFileCoverageData("this/is/not/a/direct/child.lua")
        end
      )

  self:assertIs(coverageData, fileCoverageDataMock)

end

---
-- Checks that a CoverageData.Directory can return its sorted child CoverageData.Directory's.
--
function TestDirectory:testCanReturnSortedChildDirectoryCoverages()

  local Directory = self.testClass

  local sortedCoverages

  local directory
  self:expectDirectoryInitialization()
      :when(
        function()
          directory = Directory("exampledir", self.parentDirectoryCoverageDataMock)
        end
      )

  local sortedCoveragesMock = {
    self:getMock("luacov.html.CoverageData.Directory", "dirA"),
    self:getMock("luacov.html.CoverageData.Directory", "dirB"),
    self:getMock("luacov.html.CoverageData.Directory", "dirC")
  }

  self.directoryCoverageDataCollectionMock.getSortedFileSystemEntryCoverages
      :should_be_called()
      :and_will_return(sortedCoveragesMock)
      :when(
        function()
          sortedCoverages = directory:getSortedChildDirectoryCoverages()
        end
      )

  self:assertEquals(sortedCoverages, sortedCoveragesMock)

end

---
-- Checks that a CoverageData.Directory can return its sorted child CoverageData.File's.
--
function TestDirectory:testCanReturnSortedChildFileCoverages()

  local Directory = self.testClass

  local sortedCoverages

  local directory
  self:expectDirectoryInitialization()
      :when(
        function()
          directory = Directory("exampledir", self.parentDirectoryCoverageDataMock)
        end
      )

  local sortedCoveragesMock = {
    self:getMock("luacov.html.CoverageData.File", "fileA"),
    self:getMock("luacov.html.CoverageData.File", "fileB"),
    self:getMock("luacov.html.CoverageData.File", "fileC")
  }

  self.fileCoverageDataCollectionMock.getSortedFileSystemEntryCoverages
      :should_be_called()
      :and_will_return(sortedCoveragesMock)
      :when(
        function()
          sortedCoverages = directory:getSortedChildFileCoverages()
        end
      )

  self:assertEquals(sortedCoverages, sortedCoveragesMock)

end


-- Protected Methods

---
-- Returns the required expectations for a FileSystemEntry's creation.
--
-- @treturn table The expectations
--
function TestDirectory:expectFileSystemEntryInitialization()
  return self:expectDirectoryInitialization()
end


-- Private Methods

---
-- Returns the required expectations for a CoverageData.Directory's creation.
--
-- @treturn table The expectations
--
function TestDirectory:expectDirectoryInitialization()

  return self.super.expectFileSystemEntryInitialization(self)
                   :and_also(
                     self:expectFileSystemEntryCollectionCreations()
                   )

end

---
-- Returns the required expectations for a CoverageData.Directory's FileSystemEntryCollections creations.
-- Also injects the mocks via the expectations return values.
--
-- @treturn table The expectations
--
function TestDirectory:expectFileSystemEntryCollectionCreations()

  local Directory = self.testClass
  local File = require "luacov.html.CoverageData.File"
  local FileSystemEntryCollectionMock = self.dependencyMocks.FileSystemEntryCollection

  local isInstanceOfArgumentMatcher = function(_expectedClass, _actualArgumentValue)
    return _actualArgumentValue:is(_expectedClass)
  end

  return FileSystemEntryCollectionMock.__call
                                      :should_be_called_with(
                                        self.mach.match(Directory, isInstanceOfArgumentMatcher),
                                        Directory
                                      )
                                      :and_will_return(self.directoryCoverageDataCollectionMock)
                                      :and_also(
                                        FileSystemEntryCollectionMock.__call
                                                                     :should_be_called_with(
                                                                       self.mach.match(
                                                                         Directory,
                                                                         isInstanceOfArgumentMatcher
                                                                       ),
                                                                       File
                                                                     )
                                                                     :and_will_return(
                                                                       self.fileCoverageDataCollectionMock
                                                                     )
                                      )

end


return TestDirectory
