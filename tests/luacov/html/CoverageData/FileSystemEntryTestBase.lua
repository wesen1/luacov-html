---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local TestCase = require "wLuaUnit.TestCase"

---
-- Checks that the CoverageData.FileSystemEntry class works as expected.
--
-- @type FileSystemEntryTestBase
--
local FileSystemEntryTestBase = TestCase:extend()


---
-- The mock for the parent CoverageData.Directory of the CoverageData.FileSystemEntry
--
-- @tfield table parentDirectoryCoverageDataMock
--
FileSystemEntryTestBase.parentDirectoryCoverageDataMock = nil

---
-- The mock for the CoverageData.HitMissStatistics of the CoverageData.FileSystemEntry
--
-- @tfield table hitMissStatisticsMock
--
FileSystemEntryTestBase.hitMissStatisticsMock = nil


-- Public Methods

---
-- Method that is called before a test is executed.
-- Initializes the mocks.
--
function FileSystemEntryTestBase:setUp()

  TestCase.setUp(self)
  self.parentDirectoryCoverageDataMock = self:getMock("luacov.html.CoverageData.FileSystemEntry", "DirectoryCoverageDataMock")
  self.hitMissStatisticsMock = self:getMock("luacov.html.CoverageData.Util.HitMissStatistics", "HitMissStatisticsMock")

end

---
-- Method that is called after a test was executed.
-- Clears the mocks.
--
function FileSystemEntryTestBase:tearDown()
  TestCase.tearDown(self)
  self.parentDirectoryCoverageDataMock = nil
  self.hitMissStatisticsMock = nil
end


---
-- Checks that a CoverageData.FileSystemEntry can return its base information.
-- Base information means data that is stored in the abstract CoverageData.FileSystemEntry class.
--
function FileSystemEntryTestBase:testCanReturnBaseInformation()

  local FileSystemEntry = self.testClass

  local fileSystemEntry
  self:expectFileSystemEntryInitialization()
      :when(
        function()
          fileSystemEntry = FileSystemEntry("exampleEntry", self.parentDirectoryCoverageDataMock)
        end
      )

  self:assertEquals(fileSystemEntry:getBaseName(), "exampleEntry")
  self:assertEquals(fileSystemEntry:getParentDirectoryCoverageData(), self.parentDirectoryCoverageDataMock)
  self:assertEquals(fileSystemEntry:getHitMissStatistics(), self.hitMissStatisticsMock)

end


---
-- Checks that the path CoverageData.Directory's can be calculated as expected when the root
-- CoverageData.Directory and the CoverageData.FileSystemEntry itself should be included in the result list.
--
function FileSystemEntryTestBase:testCanCalculatePathDirectoryCoveragesIncludingRootAndSelf()

  local FileSystemEntry = self.testClass

  local pathDirectoryCoverages

  local mockedParentDirectoryCoverages = {
    self:getMock("luacov.html.CoverageData.Directory", "DirectoryMockA"),
    self:getMock("luacov.html.CoverageData.Directory", "DirectoryMockB"),
    self.parentDirectoryCoverageDataMock
  }

  local fileSystemEntryWithParentDirectory
  self:expectFileSystemEntryInitialization()
      :and_then(
        self.parentDirectoryCoverageDataMock.calculatePathDirectoryCoverages
                                            :should_be_called_with(true, true)
                                            :and_will_return(mockedParentDirectoryCoverages)
      )
      :when(
        function()
          fileSystemEntryWithParentDirectory = FileSystemEntry("withParent", self.parentDirectoryCoverageDataMock)
          pathDirectoryCoverages = fileSystemEntryWithParentDirectory:calculatePathDirectoryCoverages(true, true)
        end
      )

  self:assertEquals(#pathDirectoryCoverages, 4)
  self:assertIs(pathDirectoryCoverages[1], mockedParentDirectoryCoverages[1])
  self:assertIs(pathDirectoryCoverages[2], mockedParentDirectoryCoverages[2])
  self:assertIs(pathDirectoryCoverages[3], mockedParentDirectoryCoverages[3])
  self:assertIs(pathDirectoryCoverages[4], fileSystemEntryWithParentDirectory)


  local Directory = require "luacov.html.CoverageData.Directory"
  if (self.testClass == Directory) then

    local fileSystemEntryWithoutParentDirectory
    self:expectFileSystemEntryInitialization()
        :when(
          function()
            fileSystemEntryWithoutParentDirectory = FileSystemEntry("withoutParent")
            pathDirectoryCoverages = fileSystemEntryWithoutParentDirectory:calculatePathDirectoryCoverages(true, true)
          end
        )

    self:assertEquals(#pathDirectoryCoverages, 1)
    self:assertIs(pathDirectoryCoverages[1], fileSystemEntryWithoutParentDirectory)

  end

end

---
-- Checks that the path CoverageData.Directory's can be calculated as expected when the root
-- CoverageData.Directory should be included and the CoverageData.FileSystemEntry itself should be excluded
-- from the result list.
--
function FileSystemEntryTestBase:testCanCalculatePathDirectoryCoveragesIncludingRootAndExcludingSelf()

  local FileSystemEntry = self.testClass

  local pathDirectoryCoverages

  local mockedParentDirectoryCoverages = {
    self:getMock("luacov.html.CoverageData.Directory", "DirectoryMockA"),
    self:getMock("luacov.html.CoverageData.Directory", "DirectoryMockB"),
    self.parentDirectoryCoverageDataMock
  }

  local fileSystemEntryWithParentDirectory
  self:expectFileSystemEntryInitialization()
      :and_then(
        self.parentDirectoryCoverageDataMock.calculatePathDirectoryCoverages
                                            :should_be_called_with(true, true)
                                            :and_will_return(mockedParentDirectoryCoverages)
      )
      :when(
        function()
          fileSystemEntryWithParentDirectory = FileSystemEntry("withParent", self.parentDirectoryCoverageDataMock)
          pathDirectoryCoverages = fileSystemEntryWithParentDirectory:calculatePathDirectoryCoverages(true, false)
        end
      )

  self:assertEquals(#pathDirectoryCoverages, 3)
  self:assertIs(pathDirectoryCoverages[1], mockedParentDirectoryCoverages[1])
  self:assertIs(pathDirectoryCoverages[2], mockedParentDirectoryCoverages[2])
  self:assertIs(pathDirectoryCoverages[3], mockedParentDirectoryCoverages[3])


  local Directory = require "luacov.html.CoverageData.Directory"
  if (self.testClass == Directory) then

    local fileSystemEntryWithoutParentDirectory
    self:expectFileSystemEntryInitialization()
        :when(
          function()
            fileSystemEntryWithoutParentDirectory = FileSystemEntry("withoutParent")
            pathDirectoryCoverages = fileSystemEntryWithoutParentDirectory:calculatePathDirectoryCoverages(true, false)
          end
        )

    self:assertEquals(#pathDirectoryCoverages, 0)

  end

end

---
-- Checks that the path CoverageData.Directory's can be calculated as expected when the root
-- CoverageData.Directory should be excluded and the CoverageData.FileSystemEntry itself should be included
-- in the result list.
--
function FileSystemEntryTestBase:testCanCalculatePathDirectoryCoveragesExcludingRootAndIncludingSelf()

  local FileSystemEntry = self.testClass

  local pathDirectoryCoverages

  local mockedParentDirectoryCoverages = {
    self:getMock("luacov.html.CoverageData.Directory", "DirectoryMockA"),
    self:getMock("luacov.html.CoverageData.Directory", "DirectoryMockB"),
    self.parentDirectoryCoverageDataMock
  }

  local fileSystemEntryWithParentDirectory
  self:expectFileSystemEntryInitialization()
      :and_then(
        self.parentDirectoryCoverageDataMock.calculatePathDirectoryCoverages
                                            :should_be_called_with(false, true)
                                            :and_will_return(mockedParentDirectoryCoverages)
      )
      :when(
        function()
          fileSystemEntryWithParentDirectory = FileSystemEntry("withParent", self.parentDirectoryCoverageDataMock)
          pathDirectoryCoverages = fileSystemEntryWithParentDirectory:calculatePathDirectoryCoverages(false, true)
        end
      )

  self:assertEquals(#pathDirectoryCoverages, 4)
  self:assertIs(pathDirectoryCoverages[1], mockedParentDirectoryCoverages[1])
  self:assertIs(pathDirectoryCoverages[2], mockedParentDirectoryCoverages[2])
  self:assertIs(pathDirectoryCoverages[3], mockedParentDirectoryCoverages[3])
  self:assertIs(pathDirectoryCoverages[4], fileSystemEntryWithParentDirectory)


  local Directory = require "luacov.html.CoverageData.Directory"
  if (self.testClass == Directory) then

    local fileSystemEntryWithoutParentDirectory
    self:expectFileSystemEntryInitialization()
        :when(
          function()
            fileSystemEntryWithoutParentDirectory = FileSystemEntry("withoutParent")
            pathDirectoryCoverages = fileSystemEntryWithoutParentDirectory:calculatePathDirectoryCoverages(false, true)
          end
        )

    self:assertEquals(#pathDirectoryCoverages, 0)

  end

end

---
-- Checks that the path CoverageData.Directory's can be calculated as expected when the root
-- CoverageData.Directory and the CoverageData.FileSystemEntry itself should be excluded
-- from the result list.
--
function FileSystemEntryTestBase:testCanCalculatePathDirectoryCoveragesExcludingRootAndSelf()

  local FileSystemEntry = self.testClass

  local pathDirectoryCoverages

  local mockedParentDirectoryCoverages = {
    self:getMock("luacov.html.CoverageData.Directory", "DirectoryMockA"),
    self:getMock("luacov.html.CoverageData.Directory", "DirectoryMockB"),
    self.parentDirectoryCoverageDataMock
  }

  local fileSystemEntryWithParentDirectory
  self:expectFileSystemEntryInitialization()
      :and_then(
        self.parentDirectoryCoverageDataMock.calculatePathDirectoryCoverages
                                            :should_be_called_with(false, true)
                                            :and_will_return(mockedParentDirectoryCoverages)
      )
      :when(
        function()
          fileSystemEntryWithParentDirectory = FileSystemEntry("withParent", self.parentDirectoryCoverageDataMock)
          pathDirectoryCoverages = fileSystemEntryWithParentDirectory:calculatePathDirectoryCoverages(false, false)
        end
      )

  self:assertEquals(#pathDirectoryCoverages, 3)
  self:assertIs(pathDirectoryCoverages[1], mockedParentDirectoryCoverages[1])
  self:assertIs(pathDirectoryCoverages[2], mockedParentDirectoryCoverages[2])
  self:assertIs(pathDirectoryCoverages[3], mockedParentDirectoryCoverages[3])


  local Directory = require "luacov.html.CoverageData.Directory"
  if (self.testClass == Directory) then

    local fileSystemEntryWithoutParentDirectory
    self:expectFileSystemEntryInitialization()
        :when(
          function()
            fileSystemEntryWithoutParentDirectory = FileSystemEntry("withoutParent")
            pathDirectoryCoverages = fileSystemEntryWithoutParentDirectory:calculatePathDirectoryCoverages(false, false)
          end
           )

    self:assertEquals(#pathDirectoryCoverages, 0)

  end

end


---
-- Checks that a CoverageData.FileSystemEntry can calculate its full path including the root.
--
function FileSystemEntryTestBase:testCanCalculateFullPathIncludingRoot()

  local FileSystemEntry = self.testClass

  local fullPath

  local mockedParentDirectoryCoverages = {
    self:getMock("luacov.html.CoverageData.FileSystemEntry", "DirectoryMockA"),
    self:getMock("luacov.html.CoverageData.FileSystemEntry", "DirectoryMockB"),
    self.parentDirectoryCoverageDataMock
  }
  self:expectFileSystemEntryInitialization()
      :and_then(
        self.parentDirectoryCoverageDataMock.calculatePathDirectoryCoverages
                                            :should_be_called_with(true, true)
                                            :and_will_return(mockedParentDirectoryCoverages)
      )
      :and_then(
        mockedParentDirectoryCoverages[1].getBaseName
                                         :should_be_called()
                                         :and_will_return("abc")
                                         :and_also(
                                           mockedParentDirectoryCoverages[2].getBaseName
                                                                            :should_be_called()
                                                                            :and_will_return("something")
                                         )
                                         :and_also(
                                           mockedParentDirectoryCoverages[3].getBaseName
                                                                            :should_be_called()
                                                                            :and_will_return("final")
                                         )
      )
      :when(
        function()
          local fileSystemEntry = FileSystemEntry("withParent", self.parentDirectoryCoverageDataMock)
          fullPath = fileSystemEntry:calculateFullPath(true)
        end
      )

  self:assertEquals(fullPath, "abc/something/final/withParent")


  local Directory = require "luacov.html.CoverageData.Directory"
  if (self.testClass == Directory) then

    self:expectFileSystemEntryInitialization()
        :when(
          function()
            local fileSystemEntry = FileSystemEntry("withoutParent")
            fullPath = fileSystemEntry:calculateFullPath(true)
          end
        )

    self:assertEquals(fullPath, "withoutParent")

  end

end

---
-- Checks that a CoverageData.FileSystemEntry can calculate its full path excluding the root.
--
function FileSystemEntryTestBase:testCanCalculateFullPathExcludingRoot()

  local FileSystemEntry = self.testClass

  local fullPath

  local mockedParentDirectoryCoverages = {
    self:getMock("luacov.html.CoverageData.FileSystemEntry", "DirectoryMockA"),
    self:getMock("luacov.html.CoverageData.FileSystemEntry", "DirectoryMockB"),
    self.parentDirectoryCoverageDataMock
  }
  self:expectFileSystemEntryInitialization()
      :and_then(
        self.parentDirectoryCoverageDataMock.calculatePathDirectoryCoverages
                                            :should_be_called_with(false, true)
                                            :and_will_return(mockedParentDirectoryCoverages)
      )
      :and_then(
        mockedParentDirectoryCoverages[1].getBaseName
                                         :should_be_called()
                                         :and_will_return("nothing")
                                         :and_also(
                                           mockedParentDirectoryCoverages[2].getBaseName
                                                                            :should_be_called()
                                                                            :and_will_return("anything")
                                         )
                                         :and_also(
                                           mockedParentDirectoryCoverages[3].getBaseName
                                                                            :should_be_called()
                                                                            :and_will_return("hi")
                                         )
      )
      :when(
        function()
          local fileSystemEntry = FileSystemEntry("anotherOneThatHasAParent", self.parentDirectoryCoverageDataMock)
          fullPath = fileSystemEntry:calculateFullPath(false)
        end
      )

  self:assertEquals(fullPath, "nothing/anything/hi/anotherOneThatHasAParent")


  local Directory = require "luacov.html.CoverageData.Directory"
  if (self.testClass == Directory) then

    self:expectFileSystemEntryInitialization()
        :when(
          function()
            local fileSystemEntry = FileSystemEntry("anotherParentless")
            fullPath = fileSystemEntry:calculateFullPath(false)
          end
        )

    self:assertEquals(fullPath, "")

  end

end


---
-- Checks that hit/miss statistics can be added to a CoverageData.FileSystemEntry as expected.
--
function FileSystemEntryTestBase:testCanAddHitMissStatistics()

  local FileSystemEntry = self.testClass

  self:expectFileSystemEntryInitialization()
      :and_then(
        self.hitMissStatisticsMock.addNumberOfHits
                                  :should_be_called_with(987)
                                  :and_also(
                                    self.hitMissStatisticsMock.addNumberOfMisses
                                                             :should_be_called_with(234)
                                  )
      )
      :and_also(
        self.parentDirectoryCoverageDataMock.addHitMissStatistics
          :should_be_called_with(987, 234)
      )
      :when(
        function()
          local fileSystemEntry = FileSystemEntry("withParent", self.parentDirectoryCoverageDataMock)
          fileSystemEntry:addHitMissStatistics(987, 234)
        end
      )


  local Directory = require "luacov.html.CoverageData.Directory"
  if (self.testClass == Directory) then

    self:expectFileSystemEntryInitialization()
        :and_then(
          self.hitMissStatisticsMock.addNumberOfHits
                                    :should_be_called_with(18888)
                                    :and_also(
                                      self.hitMissStatisticsMock.addNumberOfMisses
                                                                :should_be_called_with(41231)
                                    )
        )
        :when(
          function()
            local fileSystemEntry = FileSystemEntry("withoutParent")
            fileSystemEntry:addHitMissStatistics(18888, 41231)
          end
        )

  end

end


-- Protected Methods

---
-- Returns the required expectations for a CoverageData.FileSystemEntry's creation.
-- Inheriting TestCase's must add additional expectations to this method as required.
--
-- @treturn table The expectations
--
function FileSystemEntryTestBase:expectFileSystemEntryInitialization()
  return self:expectHitMissStatisticsCreation()
end

---
-- Returns the required expectations for a CoverageData.FileSystemEntry's HitMissStatistics creation.
-- Also injects the CoverageData.HitMissStatistics mock via the expectations return values.
--
-- @treturn table The expectations
--
function FileSystemEntryTestBase:expectHitMissStatisticsCreation()

  return self.dependencyMocks.HitMissStatistics.__call
                                               :should_be_called()
                                               :and_will_return(self.hitMissStatisticsMock)

end


return FileSystemEntryTestBase
