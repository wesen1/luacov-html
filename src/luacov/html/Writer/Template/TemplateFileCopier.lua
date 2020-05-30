---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local AbsoluteTemplateDirectoryPathFinder = require "luacov.html.Writer.Template.AbsoluteTemplateDirectoryPathFinder"
local dir = require "pl.dir"
local file = require "pl.file"
local Object = require "classic"
local path = require "pl.path"

---
-- Copies files from the "templates" directory to other directories.
--
-- @type TemplateFileCopier
--
local TemplateFileCopier = Object:extend()


---
-- The absolute path to the "templates" directory
--
-- @tfield string absoluteTemplateDirectoryPath
--
TemplateFileCopier.absoluteTemplateDirectoryPath = nil


---
-- TemplateFileCopier constructor.
--
function TemplateFileCopier:new()
  self.absoluteTemplateDirectoryPath = AbsoluteTemplateDirectoryPathFinder.findAbsoluteTemplateDirectoryPath()
end


-- Public Methods

---
-- Copies a file from the "templates" directory to a specified destination path.
--
-- @tparam string _relativeTemplateFilePath The path of the file to copy relative from the "templates" directory
-- @tparam string _destinationPath The destination path to copy the file to
--
function TemplateFileCopier:copyTemplateFile(_relativeTemplateFilePath, _destinationPath)
  local templateFilePath = self.absoluteTemplateDirectoryPath .. "/" .. _relativeTemplateFilePath

  dir.makepath(path.dirname(_destinationPath))
  file.copy(templateFilePath, _destinationPath)
end


return TemplateFileCopier
