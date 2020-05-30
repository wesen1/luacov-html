---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local TestCase = require "wLuaUnit.TestCase"

---
-- Checks that the FilePathNormalizer class works as expected.
--
-- @type TestFilePathNormalizer
--
local TestFilePathNormalizer = TestCase:extend()


---
-- The require path for the class that is tested by this TestCase
--
-- @tfield string testClassPath
--
TestFilePathNormalizer.testClassPath = "luacov.html.CoverageData.Util.FilePathNormalizer"


-- Public Methods

---
-- Checks that the FilePathNormalizer normalizes file paths as expected.
-- The directory references should be resolved and leading directory references should be removed.
--
function TestFilePathNormalizer:testCanNormalizeRelativePathsWithDirectoryReferences()

  local FilePathNormalizer = self.testClass

  local filePathNormalizer = FilePathNormalizer()

  local filePathA = "./../../src/./luacov/html//CoverageData/../Writer/TemplateData/../Total.lua"
  local normalizeFilePathA = filePathNormalizer:normalizeFilePath(filePathA)
  self:assertEquals(normalizeFilePathA, "src/luacov/html/Writer/Total.lua")

  local filePathB = "./src/luacov//../../test.lua"
  local normalizeFilePathB = filePathNormalizer:normalizeFilePath(filePathB)
  self:assertEquals(normalizeFilePathB, "test.lua")

end


return TestFilePathNormalizer
