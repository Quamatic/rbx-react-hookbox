local RunService = game:GetService("RunService")
local React = require(script.Parent.Parent.React)

local useEvent = require(script.Parent.useEvent)

--[=[
	@within Hooks

	Returns the current `deltaTime` from `RenderStepped`.

	@return number
]=]
local function useDeltaTime()
	local deltaTime, setDeltaTime = React.useBinding(0)
	useEvent(RunService.RenderStepped, setDeltaTime)

	return deltaTime
end

return useDeltaTime
