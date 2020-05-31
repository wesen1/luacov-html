---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local TestCase = require "wLuaUnit.TestCase"

---
-- Checks that the TemplateWriter class works as expected.
--
-- @type TestTemplateWriter
--
local TestTemplateWriter = TestCase:extend()


---
-- The require path for the class that is tested by this TestCase
--
-- @tfield string testClassPath
--
TestTemplateWriter.testClassPath = "luacov.html.Writer.Template.TemplateWriter"

---
-- The paths of the classes that the test class depends on
--
-- @tfield table[] dependencyPaths
--
TestTemplateWriter.dependencyPaths = {
  { id = "AbsoluteTemplateDirectoryPathFinder", path = "luacov.html.Writer.Template.AbsoluteTemplateDirectoryPathFinder"},
  { id = "dir", path = "pl.dir", ["type"] = "table" },
  { id = "LuaRestyTemplateEngine", path = "resty.template", ["type"] = "table" },
  { id = "io", path = "io", ["type"] = "globalVariable" },
  { id = "path", path = "pl.path", ["type"] = "table" }
}


-- Public Methods

---
-- Checks that templates can be written as expected.
--
function TestTemplateWriter:testCanWriteTemplate()

  local TemplateWriter = self.testClass

  local ioMock = self.dependencyMocks.io

  local templateWriter
  self:expectTemplateWriterInitialization("some/tpls")
      :when(
        function()
          templateWriter = TemplateWriter()
        end
      )


  -- Example A: No template values passed
  local outputFileMockA = {}
  outputFileMockA.write = self.mach.mock_method("write")
  outputFileMockA.close = self.mach.mock_method("close")

  self:expectOutputDirectoryCreation("write/to/here/file.html", "write/to/here")
      :and_then(
        ioMock.open
              :should_be_called_with("write/to/here/file.html", "w")
              :and_will_return(outputFileMockA, nil)
      )
      :and_then(
        self:expectTemplateRendering(
          "some/tpls/file.tpl",
          { templateDirectoryPath = "some/tpls" },
          "a rendered template"
        )
      )
      :and_then(
        outputFileMockA.write
                       :should_be_called_with("a rendered template")
                       :and_then(
                        outputFileMockA.close
                                       :should_be_called()
                       )
      )
      :when(
        function()
          templateWriter:writeTemplate("write/to/here/file.html", "file", {})
        end
      )


  -- Example B: Custom template values passed
  local outputFileMockB = {}
  outputFileMockB.write = self.mach.mock_method("write")
  outputFileMockB.close = self.mach.mock_method("close")

  self:expectOutputDirectoryCreation("write/this/module.html", "write/this")
      :and_then(
        ioMock.open
              :should_be_called_with("write/this/module.html", "w")
              :and_will_return(outputFileMockB, nil)
      )
      :and_then(
        self:expectTemplateRendering(
          "some/tpls/module.tpl",
          {
            templateDirectoryPath = "some/tpls",
            myValue = "printthis",
            nestedData = {
              cool = math.huge,
              notcool = false
            },
            done = "yes"
          },
          "i got the template values but did not use them!"
        )
      )
      :and_then(
        outputFileMockB.write
                       :should_be_called_with("i got the template values but did not use them!")
                       :and_then(
                        outputFileMockB.close
                                       :should_be_called()
                       )
      )
      :when(
        function()
          templateWriter:writeTemplate(
            "write/this/module.html",
            "module",
            {
              myValue = "printthis",
              nestedData = {
                cool = math.huge,
                notcool = false
              },
              done = "yes"
            }
          )
        end
           )

end

---
-- Checks that shared template values can be added as expected.
--
function TestTemplateWriter:testCanAddSharedTemplateValues()

  local TemplateWriter = self.testClass

  local ioMock = self.dependencyMocks.io

  local templateWriter
  self:expectTemplateWriterInitialization("its-another/dir/example")
      :when(
        function()
          templateWriter = TemplateWriter()
        end
      )

  -- Add some additional shared template values
  templateWriter:addSharedTemplateValues({ veryImportant = 1, notsoimportant = 2 })

  -- Example A: No template values passed
  local outputFileMockA = {}
  outputFileMockA.write = self.mach.mock_method("write")
  outputFileMockA.close = self.mach.mock_method("close")

  self:expectOutputDirectoryCreation("output-dir/report/index.html", "output-dir/report")
      :and_then(
        ioMock.open
              :should_be_called_with("output-dir/report/index.html", "w")
              :and_will_return(outputFileMockA, nil)
      )
      :and_then(
        self:expectTemplateRendering(
          "its-another/dir/example/directory.tpl",
          { templateDirectoryPath = "its-another/dir/example", veryImportant = 1, notsoimportant = 2 },
          "this is a dir template"
        )
      )
      :and_then(
        outputFileMockA.write
                       :should_be_called_with("this is a dir template")
                       :and_then(
                         outputFileMockA.close
                                        :should_be_called()
                       )
      )
      :when(
        function()
          templateWriter:writeTemplate("output-dir/report/index.html", "directory", {})
        end
           )


  -- Example B: Custom template values passed
  local outputFileMockB = {}
  outputFileMockB.write = self.mach.mock_method("write")
  outputFileMockB.close = self.mach.mock_method("close")

  self:expectOutputDirectoryCreation("output-dir/main-page.html", "output-dir")
    :and_then(
      ioMock.open
            :should_be_called_with("output-dir/main-page.html", "w")
            :and_will_return(outputFileMockB, nil)
    )
    :and_then(
      self:expectTemplateRendering(
        "its-another/dir/example/main.tpl",
        {
          templateDirectoryPath = "its-another/dir/example",
          veryImportant = 1,
          notsoimportant = 2,
          title = "Welcome Page",
          body = "Hello and welcome to this page ..."
        },
        "this is a dir template"
      )
    )
    :and_then(
      outputFileMockB.write
                     :should_be_called_with("this is a dir template")
                     :and_then(
                       outputFileMockB.close
                                      :should_be_called()
                     )
    )
    :when(
      function()
        templateWriter:writeTemplate(
          "output-dir/main-page.html",
          "main",
          { title = "Welcome Page", body = "Hello and welcome to this page ..." }
        )
      end
    )

end


---
-- Checks that io.open errors are handled as expected.
--
function TestTemplateWriter:testCanHandleIoOpenErrors()

  local TemplateWriter = self.testClass

  local ioMock = self.dependencyMocks.io

  local templateWriter
  self:expectTemplateWriterInitialization("other-tpl-dir")
      :when(
        function()
          templateWriter = TemplateWriter()
        end
      )

  self:expectOutputDirectoryCreation("write/to/here/file.html", "write/to/here")
      :and_then(
        ioMock.open
              :should_be_called_with("write/to/here/file.html", "w")
              :and_will_return(nil, "Permission denied")
      )
      :and_then(
        ioMock.write
              :should_be_called_with(
                "Could not open file \"write/to/here/file.html\" for writing: Permission denied"
              )
      )
      :when(
        function()
          templateWriter:writeTemplate("write/to/here/file.html", "file", {})
        end
      )

end


-- Private Methods

---
-- Returns the required expectations for the initialization of a TemplateWriter instance.
--
-- @tparam string _absoluteTemplateDirectoryPath The absolute template directory path that should be returned
--
-- @treturn table The expectations
--
function TestTemplateWriter:expectTemplateWriterInitialization(_absoluteTemplateDirectoryPath)
  return self:expectAbsolutTemplateDirectoryPathFetching(_absoluteTemplateDirectoryPath)
end

---
-- Returns the required expectations for the fetching of the absolute template directory path.
--
-- @tparam string _absoluteTemplateDirectoryPath The absolute template directory path that should be returned
--
-- @treturn table The expectations
--
function TestTemplateWriter:expectAbsolutTemplateDirectoryPathFetching(_absoluteTemplateDirectoryPath)

  return self.dependencyMocks.AbsoluteTemplateDirectoryPathFinder.findAbsoluteTemplateDirectoryPath
                                                                 :should_be_called()
                                                                 :and_will_return(
                                                                   _absoluteTemplateDirectoryPath
                                                                 )

end


---
-- Returns the required expectations for the rendering of a template.
--
-- @tparam string _expectedTemplatePath The expected full template path
-- @tparam table _expectedTemplateValues The expected template values
-- @tparam string _renderedTemplate The rendered template to return
--
-- @treturn table The expectations
--
function TestTemplateWriter:expectTemplateRendering(_expectedTemplatePath, _expectedTemplateValues, _renderedTemplate)

  local LuaRestyTemplateEngineMock = self.dependencyMocks.LuaRestyTemplateEngine

  local compiledTemplateMock = self.mach.mock_function("compiledTemplate")

  return LuaRestyTemplateEngineMock.compile
                                   :should_be_called_with(_expectedTemplatePath)
                                   :and_will_return(compiledTemplateMock)
                                   :and_then(
                                     compiledTemplateMock:should_be_called_with(
                                       self.mach.match(_expectedTemplateValues)
                                     )
                                     :and_will_return(_renderedTemplate)
                                   )

end

---
-- Returns the required expectations for the creation of a output directory.
--
-- @tparam string _expectedOutputFilePath The full output file path that is expected to be created
-- @tparam string _outputDirectoryPath The full output file directory path that should be returned
--
-- @treturn table The expectations
--
function TestTemplateWriter:expectOutputDirectoryCreation(_expectedOutputFilePath, _outputDirectoryPath)

  local dirMock = self.dependencyMocks.dir
  local pathMock = self.dependencyMocks.path

  return pathMock.dirname
                 :should_be_called_with(_expectedOutputFilePath)
                 :and_will_return(_outputDirectoryPath)
                 :and_then(
                   dirMock.makepath
                          :should_be_called_with(_outputDirectoryPath)
                 )

end


return TestTemplateWriter
