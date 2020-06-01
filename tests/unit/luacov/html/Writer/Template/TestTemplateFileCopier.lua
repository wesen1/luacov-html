---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local TestCase = require "wLuaUnit.TestCase"

---
-- Checks that the TemplateFileCopier class works as expected.
--
-- @type TestTemplateFileCopier
--
local TestTemplateFileCopier = TestCase:extend()


---
-- The require path for the class that is tested by this TestCase
--
-- @tfield string testClassPath
--
TestTemplateFileCopier.testClassPath = "luacov.html.Writer.Template.TemplateFileCopier"

---
-- The paths of the classes that the test class depends on
--
-- @tfield table[] dependencyPaths
--
TestTemplateFileCopier.dependencyPaths = {
  { id = "AbsoluteTemplateDirectoryPathFinder", path = "luacov.html.Writer.Template.AbsoluteTemplateDirectoryPathFinder"},
  { id = "dir", path = "pl.dir", ["type"] = "table" },
  { id = "file", path = "pl.file", ["type"] = "table" },
  { id = "path", path = "pl.path", ["type"] = "table" }
}


-- Public Methods

---
-- Checks that template files can be copied as expected.
--
function TestTemplateFileCopier:testCanCopyTemplateFile()

  local TemplateFileCopier = self.testClass

  local dirMock = self.dependencyMocks.dir
  local fileMock = self.dependencyMocks.file
  local pathMock = self.dependencyMocks.path

  local templateFileCopier
  self.dependencyMocks.AbsoluteTemplateDirectoryPathFinder.findAbsoluteTemplateDirectoryPath
                                                          :should_be_called()
                                                          :and_will_return("here/are/the/templates")
                                                          :when(
                                                            function()
                                                              templateFileCopier = TemplateFileCopier()
                                                            end
                                                          )

  pathMock.dirname
          :should_be_called_with("output-dir/style/new-style.css")
          :and_will_return("output-dir/style")
          :and_then(
            dirMock.makepath
                   :should_be_called_with("output-dir/style")
          )
          :and_then(
            fileMock.copy
                    :should_be_called_with(
                      "here/are/the/templates/style/new-style.css", "output-dir/style/new-style.css"
                    )
          )
          :when(
            function()
              templateFileCopier:copyTemplateFile("style/new-style.css", "output-dir/style/new-style.css")
            end
          )

end


return TestTemplateFileCopier
