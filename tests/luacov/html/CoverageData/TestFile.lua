---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local FileSystemEntryTestBase = require "tests.luacov.html.CoverageData.FileSystemEntryTestBase"

---
-- Checks that the CoverageData.File class works as expected.
--
-- @type TestFile
--
local TestFile = FileSystemEntryTestBase:extend()


---
-- The require path for the class that is tested by this TestCase
--
-- @tfield string testClassPath
--
TestFile.testClassPath = "luacov.html.CoverageData.File"

---
-- The paths of the classes that the test class depends on
--
-- @tfield table[] dependencyPaths
--
TestFile.dependencyPaths = {
  { id = "HitMissStatistics", path = "luacov.html.CoverageData.Util.HitMissStatistics" },
  { id = "Line", path = "luacov.html.CoverageData.Line" }
}


-- Public Methods

---
-- Checks that an empty line can be added to a CoverageData.File.
--
function TestFile:testCanAddEmptyLine()

  local File = self.testClass

  local LineMock = self.dependencyMocks.Line
  LineMock.TYPE_EMPTY = "empty"

  local file
  self:expectFileSystemEntryInitialization()
      :when(
        function()
          file = File("great.lua", self.parentDirectoryCoverageDataMock)
        end
      )

  self:assertEquals(file:getSortedLineCoverages(), {})


  local emptyLineMock = self:getMock("luacov.html.CoverageData.Line", "EmptyLineMock")
  LineMock.__call
          :should_be_called_with(LineMock.TYPE_EMPTY, "\t", 15)
          :and_will_return(emptyLineMock)
          :and_then(
            emptyLineMock.getLineNumber
                         :should_be_called()
                         :and_will_return(15)
          )
          :when(
            function()
              file:addEmptyLine(15, "\t")
            end
          )

  self:assertEquals(file:getSortedLineCoverages(), { emptyLineMock })

end

---
-- Checks that a missed line can be added to a CoverageData.File.
--
function TestFile:testCanAddMissedLine()

  local File = self.testClass

  local LineMock = self.dependencyMocks.Line
  LineMock.TYPE_MISS = "miss"

  local file
  self:expectFileSystemEntryInitialization()
      :when(
        function()
          file = File("better.lua", self.parentDirectoryCoverageDataMock)
        end
      )

  self:assertEquals(file:getSortedLineCoverages(), {})


  local missedLineMock = self:getMock("luacov.html.CoverageData.Line", "MissedLineMock")
  LineMock.__call
          :should_be_called_with(LineMock.TYPE_MISS, "  local two = 1 + 1", 3)
          :and_will_return(missedLineMock)
          :and_then(
            missedLineMock.getLineNumber
                          :should_be_called()
                          :and_will_return(3)
          )
          :when(
            function()
              file:addMissedLine(3, "  local two = 1 + 1")
            end
          )

  self:assertEquals(file:getSortedLineCoverages(), { missedLineMock })

end

---
-- Checks that a hit line can be added to a CoverageData.File.
--
function TestFile:testCanAddHitLine()

  local File = self.testClass

  local LineMock = self.dependencyMocks.Line
  LineMock.TYPE_HIT = "hit"

  local file
  self:expectFileSystemEntryInitialization()
      :when(
        function()
          file = File("better.lua", self.parentDirectoryCoverageDataMock)
        end
      )

  self:assertEquals(file:getSortedLineCoverages(), {})


  local hitLineMock = self:getMock("luacov.html.CoverageData.Line", "HitLineMock")
  LineMock.__call
          :should_be_called_with(LineMock.TYPE_HIT, "  local one = 2 - 1", 617, 45)
          :and_will_return(hitLineMock)
          :and_then(
            hitLineMock.getLineNumber
                       :should_be_called()
                       :and_will_return(617)
          )
          :when(
            function()
              file:addHitLine(617, "  local one = 2 - 1", 45)
            end
          )

  self:assertEquals(file:getSortedLineCoverages(), { hitLineMock })

end

---
-- Checks that a CoverageData.File can return its sorted CoverageData.Line's.
--
function TestFile:testCanReturnedSortedLineCoverages()

  local File = self.testClass

  local LineMock = self.dependencyMocks.Line
  LineMock.TYPE_EMPTY = "empty"
  LineMock.TYPE_MISS = "miss"
  LineMock.TYPE_HIT = "hit"

  local file
  self:expectFileSystemEntryInitialization()
      :when(
        function()
          file = File("best.lua", self.parentDirectoryCoverageDataMock)
        end
      )

  self:assertEquals(file:getSortedLineCoverages(), {})


  -- Add some lines
  local emptyLineMockA = self:getMock("luacov.html.CoverageData.Line", "EmptyLineMockA")
  local emptyLineMockB = self:getMock("luacov.html.CoverageData.Line", "EmptyLineMockA")
  local missedLineMockA = self:getMock("luacov.html.CoverageData.Line", "MissedLineMockA")
  local missedLineMockB = self:getMock("luacov.html.CoverageData.Line", "MissedLineMockB")
  local hitLineMockA = self:getMock("luacov.html.CoverageData.Line", "HitLineMockA")
  local hitLineMockB = self:getMock("luacov.html.CoverageData.Line", "HitLineMockB")

  LineMock.__call
          :should_be_called_with(LineMock.TYPE_HIT, "  return 1 + 1", 415, 13)
          :and_will_return(hitLineMockA)
          :and_then(
            hitLineMockA.getLineNumber
                        :should_be_called()
                        :and_will_return(415)
          )
          :and_then(
            LineMock.__call
                    :should_be_called_with(LineMock.TYPE_MISS, "  table.insert(list, item)", 314)
                    :and_will_return(missedLineMockA)
                    :and_then(
                      missedLineMockA.getLineNumber
                                     :should_be_called()
                                     :and_will_return(314)
                    )
          )
          :and_then(
            LineMock.__call
                    :should_be_called_with(LineMock.TYPE_EMPTY, "end", 382)
                    :and_will_return(emptyLineMockA)
                    :and_then(
                      emptyLineMockA.getLineNumber
                                    :should_be_called()
                                    :and_will_return(382)
                    )
          )
          :and_then(
            LineMock.__call
                    :should_be_called_with(LineMock.TYPE_MISS, "  isListEmpty = (#list == 0)", 250)
                    :and_will_return(missedLineMockB)
                    :and_then(
                      missedLineMockB.getLineNumber
                                     :should_be_called()
                                     :and_will_return(250)
                    )
          )
          :and_then(
            LineMock.__call
                    :should_be_called_with(LineMock.TYPE_HIT, "  clearList(list)", 387, 1)
                    :and_will_return(hitLineMockB)
                    :and_then(
                      hitLineMockB.getLineNumber
                                  :should_be_called()
                                  :and_will_return(387)
                    )
          )
          :and_then(
            LineMock.__call
                    :should_be_called_with(LineMock.TYPE_EMPTY, "  -- Just a comment", 413)
                    :and_will_return(emptyLineMockB)
                    :and_then(
                      emptyLineMockB.getLineNumber
                                    :should_be_called()
                                    :and_will_return(413)
                    )
          )
          :when(
            function()
              file:addHitLine(415, "  return 1 + 1", 13)
              file:addMissedLine(314, "  table.insert(list, item)")
              file:addEmptyLine(382, "end")
              file:addMissedLine(250, "  isListEmpty = (#list == 0)")
              file:addHitLine(387, "  clearList(list)", 1)
              file:addEmptyLine(413, "  -- Just a comment")
            end
          )


  -- Now fetch the sorted lines
  local sortedLineCoverages

  hitLineMockA.getLineNumber
              :may_be_called()
              :multiple_times(10)
              :and_will_return(415)
              :and_also(
                hitLineMockB.getLineNumber
                            :may_be_called()
                            :multiple_times(10)
                            :and_will_return(387)
              )
              :and_also(
                missedLineMockA.getLineNumber
                               :may_be_called()
                               :multiple_times(10)
                               :and_will_return(314)
              )
              :and_also(
                missedLineMockB.getLineNumber
                               :may_be_called()
                               :multiple_times(10)
                               :and_will_return(250)
              )
              :and_also(
                emptyLineMockA.getLineNumber
                              :may_be_called()
                              :multiple_times(10)
                              :and_will_return(382)
              )
              :and_also(
                emptyLineMockB.getLineNumber
                              :may_be_called()
                              :multiple_times(10)
                              :and_will_return(413)
              )
              :when(
                function()
                  sortedLineCoverages = file:getSortedLineCoverages()
                end
              )

  self:assertIs(sortedLineCoverages[1], missedLineMockB)
  self:assertIs(sortedLineCoverages[2], missedLineMockA)
  self:assertIs(sortedLineCoverages[3], emptyLineMockA)
  self:assertIs(sortedLineCoverages[4], hitLineMockB)
  self:assertIs(sortedLineCoverages[5], emptyLineMockB)
  self:assertIs(sortedLineCoverages[6], hitLineMockA)

end


return TestFile
