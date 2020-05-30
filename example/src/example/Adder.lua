
local Object = require "classic"

local Adder = Object:extend()


function Adder:add(...)

  local summands = {...}
  local sum = 0
  for _, summand in ipairs(summands) do
    sum = sum + summand
  end

  return sum

end


return Adder
