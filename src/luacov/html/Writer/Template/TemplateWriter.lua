---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local AbsoluteTemplateDirectoryPathFinder = require "luacov.html.Writer.Template.AbsoluteTemplateDirectoryPathFinder"
local dir = require "pl.dir"
local LuaRestyTemplateEngine = require "resty.template"
local Object = require "classic"
local path = require "pl.path"
local tablex = require "pl.tablex"

---
-- Renders templates and writes the results to specified file paths.
--
-- @type TemplateWriter
--
local TemplateWriter = Object:extend()


---
-- The absolute path to the "templates" directory
--
-- @tfield string absoluteTemplateDirectoryPath
--
TemplateWriter.absoluteTemplateDirectoryPath = nil

---
-- The template values that will be added to all template value tables
--
-- @tfield table sharedTemplateValues
--
TemplateWriter.sharedTemplateValues = nil


---
-- TemplateWriter constructor.
--
function TemplateWriter:new()
  self.absoluteTemplateDirectoryPath = AbsoluteTemplateDirectoryPathFinder.findAbsoluteTemplateDirectoryPath()
  self.sharedTemplateValues = {
    templateDirectoryPath = self.absoluteTemplateDirectoryPath
  }
end


-- Public Methods

---
-- Adds additional template values to the shared template values.
--
-- @tparam table _sharedTemplateValues The shared template values to add
--
function TemplateWriter:addSharedTemplateValues(_sharedTemplateValues)
  self.sharedTemplateValues = tablex.merge(self.sharedTemplateValues, _sharedTemplateValues, true)
end


---
-- Renders a template and writes the result to a specified output file path.
--
-- @tparam string _outputFilePath The output file path to write the result to
-- @tparam string _templateName The name of the template without the ".tpl" suffix
-- @tparam table _templateValues The template values to render the template with
--
function TemplateWriter:writeTemplate(_outputFilePath, _templateName, _templateValues)

  dir.makepath(path.dirname(_outputFilePath))
	local outputFile, errorMessage = io.open(_outputFilePath, "w")
	if not outputFile then
    io.write("Could not open file \"" .. _outputFilePath .. "\" for writing: " .. errorMessage)
    return
  end

	outputFile:write(self:renderTemplate(_templateName, _templateValues))
	outputFile:close()

end


-- Private Methods

---
-- Renders a template and returns the result.
--
-- @tparam string _templateName The name of the template without the ".tpl" suffix
-- @tparam table _templateValues The template values to render the template with
--
-- @treturn string The rendered template
--
function TemplateWriter:renderTemplate(_templateName, _templateValues)

  local absoluteTemplatePath = self.absoluteTemplateDirectoryPath .. "/" .. _templateName .. ".tpl"
  local compiledTemplate = LuaRestyTemplateEngine.compile(absoluteTemplatePath)

  local templateValues = tablex.merge(self.sharedTemplateValues, _templateValues, true)

  return compiledTemplate(templateValues)

end


return TemplateWriter
