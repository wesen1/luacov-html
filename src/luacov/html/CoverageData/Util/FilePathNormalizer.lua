---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"
local path = require "pl.path"

---
-- Removes all "../" and "./" from file paths.
--
-- @type FilePathNormalizer
--
local FilePathNormalizer = Object:extend()


---
-- Normalizes a given file path.
-- This means that all "../" and "./" inside the path will be removed.
--
-- @tparam string _filePath The file path to normalize
--
-- @treturn string The normalized file path
--
function FilePathNormalizer:normalizeFilePath(_filePath)

  -- Normalize the path so that "../" and "./" inside the path are removed
  local normalizedFilePath = path.normpath(_filePath)

  -- Remove all leading "../" and "./"
  normalizedFilePath = normalizedFilePath:gsub("%.?%./", "")

  return normalizedFilePath

end


return FilePathNormalizer
