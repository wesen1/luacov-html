
local Object = require "classic"

local Divider = Object:extend()


function Divider:divide(_numberA, _numberB)

  if (_numberB == 0) then
    return math.huge
  else
    return _numberA / _numberB
  end

end

function Divider:divideMultiple(...)

  local result
  for _, number in ipairs({...}) do
    if (result) then
      result = self:divide(result, number)
    else
      result = number
    end
  end

  return result

end


return Divider
