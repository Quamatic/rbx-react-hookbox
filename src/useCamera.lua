local Workspace = game:GetService("Workspace")

local React = require(script.Parent.Parent.React)
local useEvent = require(script.Parent.useEvent)

--[=[
	@within Hooks

	Returns the current camera through `Workspace.CurrentCamera`. If no camera exists, then a dummy camera is created.
	A re-render is performed when `Workspace.CurrentCamera` is changed.

	@return Camera
]=]
local function useCamera()
	local camera, setCamera = React.useState(function()
		return Workspace.CurrentCamera or Instance.new("Camera")
	end)

	useEvent(Workspace:GetPropertyChangedSignal("CurrentCamera"), function()
		if Workspace.CurrentCamera then
			setCamera(Workspace.CurrentCamera)
		end
	end)

	return camera :: Camera
end

return useCamera
