local UserInputService = game:GetService("UserInputService")

local React = require(script.Parent.Parent.React)

--[=[
	@within Hooks

	Allows you to detect click and touch events outside of specified element

	@param onClickOutside -- The callback to use when an outside click is triggered.
	@param inputs -- Input events to also consider as an outside click.
]=]
local function useClickOutside(onClickOutside: () -> (), inputs: { Enum.UserInputType | Enum.KeyCode }?)
	local ref = React.useRef(nil)

	React.useEffect(function()
		local connection = UserInputService.InputBegan:Connect(function() end)

		return function()
			connection:Disconnect()
		end
	end, { ref.current, onClickOutside, inputs })

	return ref
end

return useClickOutside
