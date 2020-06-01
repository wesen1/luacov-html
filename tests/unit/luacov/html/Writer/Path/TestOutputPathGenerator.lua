---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local TestCase = require "wLuaUnit.TestCase"

---
-- Checks that the OutputPathGenerator class works as expected.
--
-- @type TestOutputPathGenerator
--
local TestOutputPathGenerator = TestCase:extend()


---
-- The require path for the class that is tested by this TestCase
--
-- @tfield string testClassPath
--
TestOutputPathGenerator.testClassPath = "luacov.html.Writer.Path.OutputPathGenerator"


-- Public Methods

---
-- Checks that output file paths can be generated from relative file paths as expected.
--
function TestOutputPathGenerator:testCanGenerateOutputFilePathForRelativePath()

  local OutputPathGenerator = self.testClass

  local outputPathGeneratorA = OutputPathGenerator("base/dir")
  local outputPathGeneratorB = OutputPathGenerator("other/folder")
  local outputPathGeneratorC = OutputPathGenerator("trash")

  local relativePathA = "style/style.css"
  local outputFilePathA = outputPathGeneratorA:generateOutputFilePathForRelativePath(relativePathA)
  self:assertEquals(outputFilePathA, "base/dir/style/style.css")

  local relativePathB = "other/style/reset.css"
  local outputFilePathB = outputPathGeneratorB:generateOutputFilePathForRelativePath(relativePathB)
  self:assertEquals(outputFilePathB, "other/folder/other/style/reset.css")

  local relativePathC = "main.html"
  local outputFilePathC = outputPathGeneratorC:generateOutputFilePathForRelativePath(relativePathC)
  self:assertEquals(outputFilePathC, "trash/main.html")

end


---
-- Checks that an output file path for a CoverageData.Directory can be generated as expected.
--
function TestOutputPathGenerator:testCanGenerateOutputFilePathForDirectory()

  local OutputPathGenerator = self.testClass

  local outputPathGenerator = OutputPathGenerator("example-dir")

  local directoryMock = self:getMock("luacov.html.CoverageData.FileSystemEntry", "DirectoryMock")
  local outputFilePath
  self:expectDirectoryOutputFilePathGeneration(directoryMock, "this/is/a/folder")
      :when(
        function()
          outputFilePath = outputPathGenerator:generateOutputFilePathForCoverageData(directoryMock)
        end
      )

  self:assertEquals(outputFilePath, "example-dir/this/is/a/folder/index.html")

end

---
-- Checks that an output file path for a CoverageData.File can be generated as expected.
--
function TestOutputPathGenerator:testCanGenerateOutputFilePathForFile()

  local OutputPathGenerator = self.testClass

  local outputPathGenerator = OutputPathGenerator("other-example")

  local fileMock = self:getMock("luacov.html.CoverageData.FileSystemEntry", "FileMock")
  local outputFilePath
  self:expectFileOutputFilePathGeneration(fileMock, "parent/directory/path", "my_test_file.lua")
      :when(
        function()
          outputFilePath = outputPathGenerator:generateOutputFilePathForCoverageData(fileMock)
        end
      )

  self:assertEquals(outputFilePath, "other-example/parent/directory/path/my_test_file.html")

end


---
-- Checks that the OutputPathGenerator caches its generated output file paths as expected.
--
function TestOutputPathGenerator:testDoesCacheGeneratedOutputFilePaths()

  local OutputPathGenerator = self.testClass

  local outputPathGenerator = OutputPathGenerator("out")


  -- Generate a path for a directory
  local directoryMock = self:getMock("luacov.html.CoverageData.FileSystemEntry", "DirectoryMock")
  local outputFilePathA

  self:expectDirectoryOutputFilePathGeneration(directoryMock, "short/path")
      :when(
        function()
          outputFilePathA = outputPathGenerator:generateOutputFilePathForCoverageData(directoryMock)
        end
      )

  self:assertEquals(outputFilePathA, "out/short/path/index.html")
  self:assertEquals(
    outputPathGenerator:generateOutputFilePathForCoverageData(directoryMock),
    "out/short/path/index.html", "Should not recalculate the path"
  )


  -- Generate a path for a file
  local fileMock = self:getMock("luacov.html.CoverageData.FileSystemEntry", "FileMock")
  local outputFilePathB

  self:expectFileOutputFilePathGeneration(fileMock, "the/file/is/here", "another_file.lua")
      :when(
        function()
          outputFilePathB = outputPathGenerator:generateOutputFilePathForCoverageData(fileMock)
        end
      )

  self:assertEquals(outputFilePathB, "out/the/file/is/here/another_file.html")
  self:assertEquals(
    outputPathGenerator:generateOutputFilePathForCoverageData(fileMock),
    "out/the/file/is/here/another_file.html",
    "Should not recalculate the path"
  )

  self:assertEquals(
    outputPathGenerator:generateOutputFilePathForCoverageData(directoryMock),
    "out/short/path/index.html",
    "Should not recalculate the path"
  )

end


---
-- Checks that a relative path from a FileSystemEntry in a deep directory level to a FileSystemEntry
-- in a higher directory level can be calculated when the base name of the second FileSystemEntry
-- should be excluded from the relative path.
--
function TestOutputPathGenerator:testCanGenerateRelativePathFromDeepLevelToHighLevelWithoutBasename()

  local OutputPathGenerator = self.testClass

  local outputPathGenerator = OutputPathGenerator("new")

  local directoryMock = self:getMock("luacov.html.CoverageData.FileSystemEntry", "DirectoryMock")
  local fileMock = self:getMock("luacov.html.CoverageData.FileSystemEntry", "FileMock")

  local relativePath
  self:expectDirectoryOutputFilePathGeneration(directoryMock, "same/different/no/back")
      :and_also(
        self:expectFileOutputFilePathGeneration(fileMock, "same/other/go", "main.lua")
      )
      :when(
        function()
          relativePath = outputPathGenerator:generateRelativePath(directoryMock, fileMock, false)
        end
      )

  self:assertEquals(relativePath, "../../../other/go/")

end

---
-- Checks that a relative path from a FileSystemEntry to another FileSystemEntry in the same
-- directory level can be calculated as expected when the name of the second FileSystemEntry
-- should be excluded from the relative path.
--
function TestOutputPathGenerator:testCanGenerateRelativePathBetweenEntriesInSameDirectoryWithoutBasename()

  local OutputPathGenerator = self.testClass

  local outputPathGenerator = OutputPathGenerator("old")

  local fileMockA = self:getMock("luacov.html.CoverageData.FileSystemEntry", "FileMockA")
  local fileMockB = self:getMock("luacov.html.CoverageData.FileSystemEntry", "FileMockB")

  local relativePath
  self:expectDirectoryOutputFilePathGeneration(fileMockA, "the/same/folder", "fileA.lua")
      :and_also(
        self:expectFileOutputFilePathGeneration(fileMockB, "the/same/folder", "fileB.lua")
      )
      :when(
        function()
          relativePath = outputPathGenerator:generateRelativePath(fileMockA, fileMockB, false)
        end
      )

  self:assertEquals(relativePath, "./")

end

---
-- Checks that a relative path from a FileSystemEntry in a high directory level to a FileSystemEntry
-- in a deeper directory level can be calculated when the base name of the second FileSystemEntry
-- should be excluded from the relative path.
--
function TestOutputPathGenerator:testCanGenerateRelativePathFromHighLevelToDeepLevelWithoutBasename()

  local OutputPathGenerator = self.testClass

  local outputPathGenerator = OutputPathGenerator("put")

  local directoryMockA = self:getMock("luacov.html.CoverageData.FileSystemEntry", "DirectoryMockA")
  local directoryMockB = self:getMock("luacov.html.CoverageData.FileSystemEntry", "DirectoryMockB")

  local relativePath
  self:expectDirectoryOutputFilePathGeneration(directoryMockA, "this")
      :and_also(
        self:expectDirectoryOutputFilePathGeneration(directoryMockB, "this/is/a/very/deep/level/dir")
      )
      :when(
        function()
          relativePath = outputPathGenerator:generateRelativePath(directoryMockA, directoryMockB, false)
        end
      )

  self:assertEquals(relativePath, "is/a/very/deep/level/dir/")

end

---
-- Checks that a relative path from a FileSystemEntry in a different base directory than
-- the other FileSystemEntry can be calculated when the base name of the second FileSystemEntry
-- should be excluded from the relative path.
--
function TestOutputPathGenerator:testCanGenerateRelativePathBetweenEntriesInDifferentBaseDirectoriesWithoutBasename()

  local OutputPathGenerator = self.testClass

  local outputPathGenerator = OutputPathGenerator("weird")

  local fileMock = self:getMock("luacov.html.CoverageData.FileSystemEntry", "FileMock")
  local directoryMock = self:getMock("luacov.html.CoverageData.FileSystemEntry", "DirectoryMock")

  local relativePath
  self:expectFileOutputFilePathGeneration(fileMock, "other-root/test/real", "main.lua")
      :and_also(
        self:expectDirectoryOutputFilePathGeneration(directoryMock, "main/different")
      )
      :when(
        function()
          relativePath = outputPathGenerator:generateRelativePath(fileMock, directoryMock, false)
        end
      )

  -- Path should go up to the root
  self:assertEquals(relativePath, "../../../main/different/")

end


---
-- Checks that a relative path from a FileSystemEntry in a deep directory level to a FileSystemEntry
-- in a higher directory level can be calculated when the base name of the second FileSystemEntry
-- should be included in the relative path.
--
function TestOutputPathGenerator:testCanGenerateRelativePathFromDeepLevelToHighLevelWithBasename()

  local OutputPathGenerator = self.testClass

  local outputPathGenerator = OutputPathGenerator("brand-new")

  local directoryMock = self:getMock("luacov.html.CoverageData.FileSystemEntry", "DirectoryMock")
  local fileMock = self:getMock("luacov.html.CoverageData.FileSystemEntry", "FileMock")

  local relativePath
  self:expectDirectoryOutputFilePathGeneration(directoryMock, "a/new/relative/path/test")
      :and_also(
        self:expectFileOutputFilePathGeneration(fileMock, "a/new/relative/", "file.lua")
      )
      :when(
        function()
          relativePath = outputPathGenerator:generateRelativePath(directoryMock, fileMock, true)
        end
      )

  self:assertEquals(relativePath, "../../file.html")

end

---
-- Checks that a relative path from a FileSystemEntry to another FileSystemEntry in the same
-- directory level can be calculated as expected when the name of the second FileSystemEntry
-- should be included in the relative path.
--
function TestOutputPathGenerator:testCanGenerateRelativePathBetweenEntriesInSameDirectoryWithBasename()

  local OutputPathGenerator = self.testClass

  local outputPathGenerator = OutputPathGenerator("very-old")

  local fileMockA = self:getMock("luacov.html.CoverageData.FileSystemEntry", "FileMockA")
  local fileMockB = self:getMock("luacov.html.CoverageData.FileSystemEntry", "FileMockB")

  local relativePath
  self:expectDirectoryOutputFilePathGeneration(fileMockA, "really/again/same?", "aFile.lua")
      :and_also(
        self:expectFileOutputFilePathGeneration(fileMockB, "really/again/same?", "bFile.lua")
      )
      :when(
        function()
          relativePath = outputPathGenerator:generateRelativePath(fileMockA, fileMockB, true)
        end
      )

  self:assertEquals(relativePath, "./bFile.html")

end

---
-- Checks that a relative path from a FileSystemEntry in a high directory level to a FileSystemEntry
-- in a deeper directory level can be calculated when the base name of the second FileSystemEntry
-- should be included in the relative path.
--
function TestOutputPathGenerator:testCanGenerateRelativePathFromHighLevelToDeepLevelWithBasename()

  local OutputPathGenerator = self.testClass

  local outputPathGenerator = OutputPathGenerator("test-output")

  local directoryMockA = self:getMock("luacov.html.CoverageData.FileSystemEntry", "DirectoryMockA")
  local directoryMockB = self:getMock("luacov.html.CoverageData.FileSystemEntry", "DirectoryMockB")

  local relativePath
  self:expectDirectoryOutputFilePathGeneration(directoryMockA, "high")
      :and_also(
        self:expectDirectoryOutputFilePathGeneration(directoryMockB, "high/low/lower/lowest")
      )
      :when(
        function()
          relativePath = outputPathGenerator:generateRelativePath(directoryMockA, directoryMockB, true)
        end
      )

  self:assertEquals(relativePath, "low/lower/lowest/index.html")

end

---
-- Checks that a relative path from a FileSystemEntry in a different base directory than
-- the other FileSystemEntry can be calculated when the base name of the second FileSystemEntry
-- should be included in the relative path.
--
function TestOutputPathGenerator:testCanGenerateRelativePathBetweenEntriesInDifferentBaseDirectoriesWithBasename()

  local OutputPathGenerator = self.testClass

  local outputPathGenerator = OutputPathGenerator("stuff")

  local fileMock = self:getMock("luacov.html.CoverageData.FileSystemEntry", "FileMock")
  local directoryMock = self:getMock("luacov.html.CoverageData.FileSystemEntry", "DirectoryMock")

  local relativePath
  self:expectFileOutputFilePathGeneration(fileMock, "folderA/really", "main.lua")
      :and_also(
        self:expectDirectoryOutputFilePathGeneration(directoryMock, "folderB/not/really")
      )
      :when(
        function()
          relativePath = outputPathGenerator:generateRelativePath(fileMock, directoryMock, true)
        end
      )

  -- Path should go up to the root
  self:assertEquals(relativePath, "../../folderB/not/really/index.html")

end


-- Private Methods

---
-- Returns the required expectations for a CoverageData.Directory's output file path generation.
--
-- @tparam CoverageData.Directory _directoryMock The directory mock whose output file path is expected to be generated
-- @tparam string _directoryPath The directory path that the mock should return as full path
--
-- @treturn table The expectations
--
function TestOutputPathGenerator:expectDirectoryOutputFilePathGeneration(_directoryMock, _directoryPath)

  local Directory = require "luacov.html.CoverageData.Directory"

  _directoryMock.is = self.mach.mock_method("is")

  return _directoryMock.is
                       :should_be_called_with(Directory)
                       :and_will_return(true)
                       :and_then(
                         _directoryMock.calculateFullPath
                                       :should_be_called_with(false)
                                       :and_will_return(_directoryPath)
                       )

end

---
-- Returns the required expectations for a CoverageData.File's output file path generation.
--
-- @tparam CoverageData.File _fileMock The file mock whose output file path is expected to be generated
-- @tparam string _parentDirectoryPath The parent directory path that the parent directory mock should return as full path
-- @tparam string _fileName The file name that the mock should return as basename
--
-- @treturn table The expectations
--
function TestOutputPathGenerator:expectFileOutputFilePathGeneration(_fileMock, _parentDirectoryPath, _fileName)

  local Directory = require "luacov.html.CoverageData.Directory"
  local File = require "luacov.html.CoverageData.File"

  local parentDirectoryMock = self:getMock("luacov.html.CoverageData.FileSystemEntry", "ParentDirectoryMock")
  _fileMock.is = self.mach.mock_method("is")

  return _fileMock.is
                  :should_be_called_with(Directory)
                  :and_will_return(false)
                  :and_then(
                    _fileMock.is
                             :should_be_called_with(File)
                             :and_will_return(true)
                  )
                  :and_then(
                    _fileMock.getParentDirectoryCoverageData
                             :should_be_called()
                             :and_will_return(parentDirectoryMock)
                  )
                  :and_then(
                    parentDirectoryMock.calculateFullPath
                                       :should_be_called_with(false)
                                       :and_will_return(_parentDirectoryPath)
                  )
                  :and_then(
                    _fileMock.getBaseName
                             :should_be_called()
                             :and_will_return(_fileName)
                  )

end


return TestOutputPathGenerator
