---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"
local path = require "pl.path"

---
-- Provides methods to find the absolute path to the directory that contains the templates.
--
-- @type AbsoluteTemplateDirectoryPathFinder
--
local AbsoluteTemplateDirectoryPathFinder = Object:extend()


---
-- The absolute path to the "templates" directory
--
-- @tfield string absoluteTemplateDirectoryPath
--
AbsoluteTemplateDirectoryPathFinder.absoluteTemplateDirectoryPath = nil


-- Public Methods

---
-- Finds and returns the absolute path to the "templates" directory.
--
-- @treturn string The absolute path to the "templates" directory
--
function AbsoluteTemplateDirectoryPathFinder.findAbsoluteTemplateDirectoryPath()

  if (AbsoluteTemplateDirectoryPathFinder.absoluteTemplateDirectoryPath == nil) then

    local ownFilePath = path.package_path("luacov.html.Writer.Template.AbsoluteTemplateDirectoryPathFinder")
    local absoluteTemplateDirectoryPath = path.dirname(ownFilePath) .. "/../templates"

    AbsoluteTemplateDirectoryPathFinder.absoluteTemplateDirectoryPath = path.normpath(absoluteTemplateDirectoryPath)

  end

  return AbsoluteTemplateDirectoryPathFinder.absoluteTemplateDirectoryPath

end


return AbsoluteTemplateDirectoryPathFinder
