---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local TestCase = require "wLuaUnit.TestCase"

---
-- Checks that the AbsoluteTemplateDirectoryPathFinder class works as expected.
--
-- @type TestAbsoluteTemplateDirectoryPathFinder
--
local TestAbsoluteTemplateDirectoryPathFinder = TestCase:extend()


---
-- The require path for the class that is tested by this TestCase
--
-- @tfield string testClassPath
--
TestAbsoluteTemplateDirectoryPathFinder.testClassPath = "luacov.html.Writer.Template.AbsoluteTemplateDirectoryPathFinder"

---
-- The paths of the classes that the test class depends on
--
-- @tfield table[] dependencyPaths
--
TestAbsoluteTemplateDirectoryPathFinder.dependencyPaths = {
  { id = "path", path = "pl.path", ["type"] = "table" }
}


-- Public Methods

---
-- Checks that the absolute template directory path can be found as expected.
--
function TestAbsoluteTemplateDirectoryPathFinder:testCanFindAbsoluteTemplateDirectoryPath()

  local AbsoluteTemplateDirectoryPathFinder = self.testClass

  local pathMock = self.dependencyMocks.path

  local templateDirectoryPath
  pathMock.package_path
          :should_be_called_with("luacov.html.Writer.Template.AbsoluteTemplateDirectoryPathFinder")
          :and_will_return("package/was/found/here/AbsoluteTemplateDirectoryPathFinder.lua")
          :and_then(
            pathMock.dirname
                    :should_be_called_with("package/was/found/here/AbsoluteTemplateDirectoryPathFinder.lua")
                    :and_will_return("package/was/found/here")
          )
          :and_then(
            pathMock.normpath
                    :should_be_called_with("package/was/found/here/../templates")
                    :and_will_return("package/was/found/templates")
          )
          :when(
            function()
              templateDirectoryPath = AbsoluteTemplateDirectoryPathFinder.findAbsoluteTemplateDirectoryPath()
            end
          )

  self:assertEquals(templateDirectoryPath, "package/was/found/templates")

  self:assertEquals(
    AbsoluteTemplateDirectoryPathFinder.findAbsoluteTemplateDirectoryPath(),
    "package/was/found/templates",
    "Should not recalculate the absolute template directory path"
  )

end


return TestAbsoluteTemplateDirectoryPathFinder
