---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local TestCase = require "wLuaUnit.TestCase"

---
-- Checks that the Configuration class works as expected.
--
-- @type TestConfiguration
--
local TestConfiguration = TestCase:extend()


---
-- The require path for the class that is tested by this TestCase
--
-- @tfield string testClassPath
--
TestConfiguration.testClassPath = "luacov.html.Configuration"


-- Public Methods

---
-- Checks that the Configuration can handle non table LuaCov configurations.
--
function TestConfiguration:testCanParseNonTableLuaCovConfiguration()

  local Configuration = self.testClass

  local configurationA = Configuration(nil)
  self:assertEquals(configurationA:getOutputDirectoryPath(), "luacov-html")
  self:assertEquals(configurationA:getProjectName(), "All Files")

  local configurationB = Configuration("a")
  self:assertEquals(configurationB:getOutputDirectoryPath(), "luacov-html")
  self:assertEquals(configurationB:getProjectName(), "All Files")

  local configurationC = Configuration(false)
  self:assertEquals(configurationC:getOutputDirectoryPath(), "luacov-html")
  self:assertEquals(configurationC:getProjectName(), "All Files")

end

---
-- Checks that the Configuration can handle non table HTML Reporter configurations inside
-- the LuaCov configuration table.
--
function TestConfiguration:testCanParseNonTableHtmlReporterConfiguration()

  local Configuration = self.testClass

  local configurationA = Configuration({ html = 7.5 })
  self:assertEquals(configurationA:getOutputDirectoryPath(), "luacov-html")
  self:assertEquals(configurationA:getProjectName(), "All Files")

  local configurationB = Configuration({ html = "a" })
  self:assertEquals(configurationB:getOutputDirectoryPath(), "luacov-html")
  self:assertEquals(configurationB:getProjectName(), "All Files")

  local configurationC = Configuration({ html = true })
  self:assertEquals(configurationC:getOutputDirectoryPath(), "luacov-html")
  self:assertEquals(configurationC:getProjectName(), "All Files")

end

---
-- Checks that the Configuration can handle an empty HTML Reporter configuration inside
-- the LuaCov configuration table.
--
function TestConfiguration:testCanParseEmptyHtmlReporterConfiguration()

  local Configuration = self.testClass

  local configuration = Configuration({ html = {} })
  self:assertEquals(configuration:getOutputDirectoryPath(), "luacov-html")
  self:assertEquals(configuration:getProjectName(), "All Files")

end

---
-- Checks that the Configuration can parse the output directory path from a valid HTML
-- Reporter configuration inside the LuaCov configuration table.
--
function TestConfiguration:testCanParseOutputDirectoryPathFromHtmlReporterConfiguration()

  local Configuration = self.testClass

  local configuration = Configuration({ html = { outputDirectory = "a/test/path" } })
  self:assertEquals(configuration:getOutputDirectoryPath(), "a/test/path")
  self:assertEquals(configuration:getProjectName(), "All Files")

end

---
-- Checks that the Configuration can parse the project name from a valid HTML Reporter
-- configuration inside the LuaCov configuration table.
--
function TestConfiguration:testCanParseProjectNameFromHtmlReporterConfiguration()

  local Configuration = self.testClass

  local configuration = Configuration({ html = { projectName = "MyProject" } })
  self:assertEquals(configuration:getOutputDirectoryPath(), "luacov-html")
  self:assertEquals(configuration:getProjectName(), "MyProject")

end

---
-- Checks that the Configuration can parse multiple config values at once from a valid HTML Reporter
-- configuration inside the LuaCov configuration table.
--
function TestConfiguration:testCanParseMultipleConfigValuesFromHtmlReporterConfiguration()

  local Configuration = self.testClass

  local configuration = Configuration({
      html = {
        outputDirectory = "coverage-report",
        projectName = "RealProj"
      }
  })
  self:assertEquals(configuration:getOutputDirectoryPath(), "coverage-report")
  self:assertEquals(configuration:getProjectName(), "RealProj")

end


return TestConfiguration
