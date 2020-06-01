---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local TestCase = require "wLuaUnit.TestCase"

---
-- Checks that the FileSystemEntryCollection class works as expected.
--
-- @type TestFileSystemEntryCollection
--
local TestFileSystemEntryCollection = TestCase:extend()


---
-- The require path for the class that is tested by this TestCase
--
-- @tfield string testClassPath
--
TestFileSystemEntryCollection.testClassPath = "luacov.html.CoverageData.Util.FileSystemEntryCollection"


-- Public Methods

---
-- Checks that a FileSystemEntryCollection can return a requested CoverageData.FileSystemEntry and create a
-- new CoverageData.FileSystemEntry instance if required.
--
function TestFileSystemEntryCollection:testCanGetOrCreateCoverageData()

  local FileSystemEntryCollection = self.testClass

  local parentDirectoryCoverageDataMock = self:getMock("luacov.html.CoverageData.Directory", "DirectoryCoverageDataMock")
  local fileSystemEntryClassMock = self:createClassMock("luacov.html.CoverageData.FileSystemEntry", "FileSystemEntryClassMock")


  local collection = FileSystemEntryCollection(parentDirectoryCoverageDataMock, fileSystemEntryClassMock)
  local coverageData

  local fileACoverageDataMock = self:getMock("luacov.html.CoverageData.File", "FileACoverageDataMock")
  fileSystemEntryClassMock.__call
                          :should_be_called_with("fileA", parentDirectoryCoverageDataMock)
                          :and_will_return(fileACoverageDataMock)
                          :when(
                            function()
                              coverageData = collection:getOrCreateCoverageData("fileA")
                            end
                          )

  self:assertIs(coverageData, fileACoverageDataMock)
  self:assertIs(collection:getOrCreateCoverageData("fileA"), fileACoverageDataMock)

  local fileBCoverageDataMock = self:getMock("luacov.html.CoverageData.File", "FileBCoverageDataMock")
  fileSystemEntryClassMock.__call
                          :should_be_called_with("fileB", parentDirectoryCoverageDataMock)
                          :and_will_return(fileBCoverageDataMock)
                          :when(
                            function()
                              coverageData = collection:getOrCreateCoverageData("fileB")
                            end
                          )

  self:assertIs(coverageData, fileBCoverageDataMock)
  self:assertIs(collection:getOrCreateCoverageData("fileA"), fileACoverageDataMock)
  self:assertIs(collection:getOrCreateCoverageData("fileB"), fileBCoverageDataMock)

end

---
-- Checks that a FileSystemEntryCollection can return all created CoverageData.FileSystemEntry's sorted
-- by their names.
--
function TestFileSystemEntryCollection:testCanReturnCoveragesSortedByName()

  local FileSystemEntryCollection = self.testClass

  local parentDirectoryCoverageDataMock = self:getMock("luacov.html.CoverageData.Directory", "DirectoryCoverageDataMock")
  local fileSystemEntryClassMock = self:createClassMock("luacov.html.CoverageData.FileSystemEntry", "FileSystemEntryClassMock")


  local collection = FileSystemEntryCollection(parentDirectoryCoverageDataMock, fileSystemEntryClassMock)
  self:assertEquals(collection:getSortedFileSystemEntryCoverages(), {})

  local aFileCoverageDataMock = self:getMock("luacov.html.CoverageData.FileSystemEntry", "AFileACoverageDataMock")
  local bFileCoverageDataMock = self:getMock("luacov.html.CoverageData.FileSystemEntry", "BFileCoverageDataMock")
  local cFileCoverageDataMock = self:getMock("luacov.html.CoverageData.FileSystemEntry", "CFileCoverageDataMock")

  fileSystemEntryClassMock.__call
                          :should_be_called_with("cFile", parentDirectoryCoverageDataMock)
                          :and_will_return(cFileCoverageDataMock)
                          :and_then(
                            fileSystemEntryClassMock.__call
                                                    :should_be_called_with(
                                                      "aFile", parentDirectoryCoverageDataMock
                                                    )
                                                    :and_will_return(aFileCoverageDataMock)
                          )
                          :and_then(
                            fileSystemEntryClassMock.__call
                                                    :should_be_called_with(
                                                      "bFile", parentDirectoryCoverageDataMock
                                                    )
                                                    :and_will_return(bFileCoverageDataMock)
                          )
                          :when(
                            function()
                              collection:getOrCreateCoverageData("cFile")
                              collection:getOrCreateCoverageData("aFile")
                              collection:getOrCreateCoverageData("bFile")
                            end
                          )

  local sortedCoverages
  aFileCoverageDataMock.getBaseName
                       :may_be_called()
                       :multiple_times(10)
                       :and_will_return("aFile")
                       :and_also(
                         bFileCoverageDataMock.getBaseName
                                              :may_be_called()
                                              :multiple_times(10)
                                              :and_will_return("bFile")
                       )
                       :and_also(
                         cFileCoverageDataMock.getBaseName
                                              :may_be_called()
                                              :multiple_times(10)
                                              :and_will_return("cFile")
                       )
                       :when(
                         function()
                           sortedCoverages = collection:getSortedFileSystemEntryCoverages()
                         end
                       )

  self:assertEquals(#sortedCoverages, 3)
  self:assertIs(sortedCoverages[1], aFileCoverageDataMock)
  self:assertIs(sortedCoverages[2], bFileCoverageDataMock)
  self:assertIs(sortedCoverages[3], cFileCoverageDataMock)

end


return TestFileSystemEntryCollection
