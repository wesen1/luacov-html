
local Object = require "classic"

local Multiplier = Object:extend()


function Multiplier:multiply(_numberA, _numberB)
  return _numberA * _numberB
end


return Multiplier
