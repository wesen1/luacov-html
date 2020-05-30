
local Object = require "classic"

local Subtractor = Object:extend()


function Subtractor:subtract(_numberA, _numberB)
  return _numberA - _numberB
end


return Subtractor
