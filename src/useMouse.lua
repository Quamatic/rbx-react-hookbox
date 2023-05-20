local UserInputService = game:GetService("UserInputService")

local React = require(script.Parent.Parent.React)

--[=[
	@interface UseMouse
	@within Hooks

	.ref { current: any } | () -> () -- The ref object used for mouse location inside elements
	.x number -- The X location of the mouse.
	.y number -- The Y location of the mouse.
]=]

--[=[
	@within Hooks

	Provides the current location of the client's mouse.

	@return UseMouse
]=]
local function useMouse()
	local ref = React.useRef(nil)
	local coordinates, setCoordinates = React.useState(Vector2.zero)

	React.useEffect(function()
		local connection: RBXScriptConnection

		local function setMouseLocation(input: InputObject)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				setCoordinates(input.Position)
			end
		end

		if not ref.current then
			connection = UserInputService.InputChanged:Connect(setMouseLocation)
		else
			connection = ref.current.InputChanged:Connect(setMouseLocation)
		end

		return function()
			connection:Disconnect()
		end
	end, { ref.current })

	return {
		ref = ref,
		x = coordinates.X,
		y = coordinates.Y,
	}
end

return useMouse
