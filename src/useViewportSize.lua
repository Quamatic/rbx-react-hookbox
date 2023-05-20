local React = require(script.Parent.Parent.React)

local useCamera = require(script.Parent.useCamera)
local useEvent = require(script.Parent.useEvent)

--[=[
	@within Hooks

	Returns the current viewport width and height.

	@return Vector2
]=]
local function useViewportSize()
	local camera = useCamera()
	local windowSize, setWindowSize = React.useState(camera.ViewportSize)

	useEvent(camera:GetPropertyChangedSignal("ViewportSize"), function()
		setWindowSize(camera.ViewportSize)
	end)

	return windowSize :: Vector2
end

return useViewportSize
