local UserInputService = game:GetService("UserInputService")

local React = require(script.Parent.Parent.React)
local Array = require(script.Parent.Parent.Collections).Array
local JSTimers = require(script.Parent.Parent.Timers)

local useEvent = require(script.Parent.useEvent)

local DEFAULT_EVENTS = {
	Enum.UserInputType.Keyboard,
	Enum.UserInputType.MouseButton1,
	Enum.UserInputType.MouseButton2,
	Enum.UserInputType.MouseButton3,
	Enum.UserInputType.Touch,
	Enum.UserInputType.Gamepad1,
}

--[=[
	@within Hooks

	Determines whether the client is currently idle or not. By default, the client is determined idle if
	the keyboard, gamepad, touchscreen, or mouse has not been interacted with within a certain timespan.

	@param timeout -- The timeout required to be considered idle. By default, 20 seconds.
	@return boolean
]=]
local function useIdle(timeout: number)
	local idle, setIdle = React.useState(false)
	local timer = React.useRef(nil)

	local handleEvents = React.useCallback(function()
		setIdle(false)

		if timer.current then
			JSTimers.clearTimeout(timer.current)
		end

		timer.current = JSTimers.setTimeout(function()
			setIdle(true)
		end, timeout)
	end, { timeout })

	useEvent(UserInputService.InputBegan, function(input: InputObject)
		if Array.includes(DEFAULT_EVENTS, input.UserInputType) then
			handleEvents()
		end
	end)

	return idle
end

return useIdle
