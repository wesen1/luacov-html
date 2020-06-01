---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local TestCase = require "wLuaUnit.TestCase"

---
-- Checks that the Writer class works as expected.
--
-- @type TestWriter
--
local TestWriter = TestCase:extend()


---
-- The require path for the class that is tested by this TestCase
--
-- @tfield string testClassPath
--
TestWriter.testClassPath = "luacov.html.Writer.Writer"

---
-- The paths of the classes that the test class depends on
--
-- @tfield table[] dependencyPaths
--
TestWriter.dependencyPaths = {
  { id = "OutputPathGenerator", path = "luacov.html.Writer.Path.OutputPathGenerator" },
  { id = "TemplateDataFactory", path = "luacov.html.Writer.TemplateData.TemplateDataFactory" },
  { id = "TemplateFileCopier", path = "luacov.html.Writer.Template.TemplateFileCopier" },
  { id = "TemplateWriter", path = "luacov.html.Writer.Template.TemplateWriter" }
}


---
-- The OutputPathGenerator mock
--
-- @tfield table outputPathGeneratorMock
--
TestWriter.outputPathGeneratorMock = nil

---
-- The TemplateDataFactory mock
--
-- @tfield table templateDataFactoryMock
--
TestWriter.templateDataFactoryMock = nil

---
-- The TemplateFileCopier mock
--
-- @tfield table templateFileCopierMock
--
TestWriter.templateFileCopierMock = nil

---
-- The TemplateWriter mock
--
-- @tfield table templateWriterMock
--
TestWriter.templateWriterMock = nil


-- Public Methods

---
-- Method that is called before a test is executed.
-- Initializes the mocks.
--
function TestWriter:setUp()

  TestCase.setUp(self)

  self.outputPathGeneratorMock = self:getMock(
    "luacov.html.Writer.Path.OutputPathGenerator", "OutputPathGeneratorMock"
  )
  self.templateDataFactoryMock = self:getMock(
    "luacov.html.Writer.TemplateData.TemplateDataFactory", "TemplateDataFactoryMock"
  )
  self.templateFileCopierMock = self:getMock(
    "luacov.html.Writer.Template.TemplateFileCopier", "TemplateFileCopierMock"
  )
  self.templateWriterMock = self:getMock(
    "luacov.html.Writer.Template.TemplateWriter", "TemplateWriterMock"
  )

end

---
-- Method that is called after a test was executed.
-- Clears the mocks.
--
function TestWriter:tearDown()
  TestCase.tearDown(self)

  self.outputPathGeneratorMock = nil
  self.templateDataFactoryMock = nil
  self.templateFileCopierMock = nil
  self.templateWriterMock = nil
end


---
-- Checks that a CoverageData.Total can be written as expected.
--
function TestWriter:testCanWriteTotalCoverage()

  local writer = self:createWriterInstance("out/put/here")

  local totalCoverageDataMock = self:getMock("luacov.html.CoverageData.Total", "TotalCoverageDataMock")
  local rootDirectoryCoverageDataMock = self:getMock(
    "luacov.html.CoverageData.Directory", "RootDirectoryCoverageDataMock"
  )
  local totalTemplateDataMock = self:getMock(
    "luacov.html.Writer.TemplateData.Total", "TotalTemplateDataMock"
  )

  totalCoverageDataMock.getRootDirectoryCoverageData
                       :should_be_called()
                       :and_will_return(rootDirectoryCoverageDataMock)
                       :and_then(
                         self.templateDataFactoryMock.setRootDirectory
                                                     :should_be_called_with(rootDirectoryCoverageDataMock)
                       )
                       :and_then(
                         self.templateDataFactoryMock.createTotalTemplateData
                                                     :should_be_called_with(totalCoverageDataMock)
                                                     :and_will_return(totalTemplateDataMock)
                       )
                       :and_then(
                         totalTemplateDataMock.toTemplateValues
                                              :should_be_called()
                                              :and_will_return({ startTimestamp = "2020-06-01 15:04:20" })
                       )
                       :and_then(
                         self.templateWriterMock.addSharedTemplateValues
                                                :should_be_called_with(
                                                  self.mach.match({ startTimestamp = "2020-06-01 15:04:20" })
                                                )
                       )
                       :and_then(
                         self:expectDirectoryCoverageWrite(
                           rootDirectoryCoverageDataMock,
                           {
                             {
                               { 4 },
                               3
                             },
                             {
                               { 2 }
                             },
                             {
                               4
                             },
                             1
                           }
                         )
                       )
    :and_also(
      self.outputPathGeneratorMock.generateOutputFilePathForRelativePath
                                  :should_be_called_with("style/reset.css")
                                  :and_will_return("abs/path/style/reset.css")
                                  :and_then(
                                    self.templateFileCopierMock.copyTemplateFile
                                                               :should_be_called_with(
                                                                 "style/reset.css",
                                                                 "abs/path/style/reset.css"
                                                               )
                                  )
    )
    :and_also(
      self.outputPathGeneratorMock.generateOutputFilePathForRelativePath
                                  :should_be_called_with("style/style.css")
                                  :and_will_return("abs/path/style/style.css")
                                  :and_then(
                                    self.templateFileCopierMock.copyTemplateFile
                                                               :should_be_called_with(
                                                                 "style/style.css",
                                                                 "abs/path/style/style.css"
                                                               )
                                  )
    )
    :when(
      function()
        writer:writeTotalCoverage(totalCoverageDataMock)
      end
    )

end


-- Private Methods

---
-- Creates and returns a Writer instance.
-- Also injects the mocks into the instance.
--
-- @tparam string _baseOutputDirectoryPath The base output directory path to construct the Writer instance with
--
-- @treturn Writer The created Writer instance
--
function TestWriter:createWriterInstance(_baseOutputDirectoryPath)

  local Writer = self.testClass

  local writer
  self.dependencyMocks.OutputPathGenerator.__call
      :should_be_called_with(_baseOutputDirectoryPath)
      :and_will_return(self.outputPathGeneratorMock)
      :and_then(
        self.dependencyMocks.TemplateDataFactory.__call
            :should_be_called_with(self.outputPathGeneratorMock)
            :and_will_return(self.templateDataFactoryMock)
      )
      :and_also(
        self.dependencyMocks.TemplateFileCopier.__call
            :should_be_called()
            :and_will_return(self.templateFileCopierMock)
      )
      :and_also(
        self.dependencyMocks.TemplateWriter.__call
            :should_be_called()
            :and_will_return(self.templateWriterMock)
      )
      :when(
        function()
          writer = Writer(_baseOutputDirectoryPath)
        end
      )

  return writer

end


---
-- Returns the required expectations for a CoverageData.Directory write.
--
-- The numbers of file system entries must be in this format:
-- {
--   { <int> },  -- Sets up a child directory with x child files
--   <int>,      -- Sets up x child files
--   ...
-- }
--
-- @tparam table _directoryCoverageDataMock The CoverageData.Directory that is expected to be written by the Writer
-- @tparam table _numbersOfFileSystemEntries The child file system entries to set up
-- @tparam string _idPrefix The id prefix for the directory (Used for recursion)
--
-- @treturn table The expectations
--
function TestWriter:expectDirectoryCoverageWrite(_directoryCoverageDataMock, _numbersOfFileSystemEntries, _idPrefix)

  local idPrefix = _idPrefix and _idPrefix or ""

  local fileWriteExpectations, directoryWriteExpectations

  local childDirectoryCoverages = {}
  local childFileCoverages = {}

  local directoryCoverageDataMock, fileCoverageDataMock
  local childDirectoryIdentifer, childFileIdentifier
  local expectation
  for i, numberOfFileSystemEntries in ipairs(_numbersOfFileSystemEntries) do

    if (type(numberOfFileSystemEntries) == "table") then
      -- Child directory config
      childDirectoryIdentifer = idPrefix .. "d#" .. i

      directoryCoverageDataMock = self:getMock(
        "luacov.html.CoverageData.Directory", "Directory_" .. childDirectoryIdentifer
      )
      expectation = self:expectDirectoryCoverageWrite(
                        directoryCoverageDataMock,
                        numberOfFileSystemEntries,
                        childDirectoryIdentifer .. "_"
                      )

      if (directoryWriteExpectations) then
        directoryWriteExpectations:and_also(expectation)
      else
        directoryWriteExpectations = expectation
      end

      table.insert(childDirectoryCoverages, directoryCoverageDataMock)

    else
      -- Number of child files
      for j = 1, numberOfFileSystemEntries, 1 do
        childFileIdentifier = idPrefix .. "f#" .. j
        fileCoverageDataMock = self:getMock(
          "luacov.html.CoverageData.File", "File_" .. childFileIdentifier
        )

        expectation = self:expectFilePageWrite(
          fileCoverageDataMock,
          "fileout_" .. childFileIdentifier,
          { [childFileIdentifier .. "_val"] = j * i }
        )

        if (fileWriteExpectations) then
          fileWriteExpectations:and_also(expectation)
        else
          fileWriteExpectations = expectation
        end

        table.insert(childFileCoverages, fileCoverageDataMock)
      end

    end

  end


  local childFileCoverageExpectations = _directoryCoverageDataMock.getSortedChildFileCoverages
                                                                  :should_be_called()
                                                                  :and_will_return(childFileCoverages)
  if (fileWriteExpectations) then
    childFileCoverageExpectations:and_then(fileWriteExpectations)
  end

  local childDirectoryCoveragExpectations = _directoryCoverageDataMock.getSortedChildDirectoryCoverages
                                                                      :should_be_called()
                                                                      :and_will_return(childDirectoryCoverages)
  if (directoryWriteExpectations) then
    childDirectoryCoveragExpectations:and_then(directoryWriteExpectations)
  end

  return self:expectDirectoryPageWrite(
           _directoryCoverageDataMock,
           "outdir_" .. idPrefix,
           { ["value_" .. idPrefix] = idPrefix:reverse() }
         )
         :and_also(
           childFileCoverageExpectations
         )
         :and_also(
           childDirectoryCoveragExpectations
         )

end

---
-- Returns the required expectations for a CoverageData.Directory's HTML page generation.
--
-- @tparam table _directoryCoverageDataMock The CoverageData.Directory mock whose HTML page is expected to be generated
-- @tparam string _outputFilePath The output file path to return
-- @tparam string _templateValues The template values to return to represent the CoverageData.Directory
--
-- @treturn table The expectations
--
function TestWriter:expectDirectoryPageWrite(_directoryCoverageDataMock, _outputFilePath, _templateValues)

  local directoryTemplateDataMock = self:getMock(
    "luacov.html.Writer.TemplateData.Directory", "DirectoryTemplateDataMock"
  )

  return self.outputPathGeneratorMock.generateOutputFilePathForCoverageData
                                     :should_be_called_with(_directoryCoverageDataMock)
                                     :and_will_return(_outputFilePath)
                                     :and_also(
                                       self.templateDataFactoryMock.createDirectoryTemplateData
                                           :should_be_called_with(_directoryCoverageDataMock)
                                           :and_will_return(directoryTemplateDataMock)
                                           :and_then(
                                             directoryTemplateDataMock.toTemplateValues
                                                                      :should_be_called()
                                                                      :and_will_return(_templateValues)
                                           )
                                     )
                                     :and_then(
                                       self.templateWriterMock.writeTemplate
                                                              :should_be_called_with(
                                                                _outputFilePath,
                                                                "directory",
                                                                _templateValues
                                                              )
                                     )

end

---
-- Returns the required expectations for a CoverageData.File's HTML page generation.
--
-- @tparam table _fileCoverageDataMock The CoverageData.File mock whose HTML page is expected to be generated
-- @tparam string _outputFilePath The output file path to return
-- @tparam string _templateValues The template values to return to represent the CoverageData.File
--
-- @treturn table The expectations
--
function TestWriter:expectFilePageWrite(_fileCoverageDataMock, _outputFilePath, _templateValues)

  local fileTemplateDataMock = self:getMock("luacov.html.Writer.TemplateData.File", "FileTemplateDataMock")

  return self.outputPathGeneratorMock.generateOutputFilePathForCoverageData
                                     :should_be_called_with(_fileCoverageDataMock)
                                     :and_will_return(_outputFilePath)
                                     :and_also(
                                       self.templateDataFactoryMock.createFileTemplateData
                                           :should_be_called_with(_fileCoverageDataMock)
                                           :and_will_return(fileTemplateDataMock)
                                           :and_then(
                                             fileTemplateDataMock.toTemplateValues
                                                                 :should_be_called()
                                                                 :and_will_return(_templateValues)
                                           )
                                     )
                                     :and_then(
                                       self.templateWriterMock.writeTemplate
                                                              :should_be_called_with(
                                                                _outputFilePath,
                                                                "file",
                                                                _templateValues
                                                              )
                                     )

end


return TestWriter
