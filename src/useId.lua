local HttpService = game:GetService("HttpService")
local React = require(script.Parent.Parent.React)

local function useId()
	return React.useRef(`zenith-{HttpService:GenerateGUID(false)}`).current
end

return useId
