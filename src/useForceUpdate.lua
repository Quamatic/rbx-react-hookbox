local React = require(script.Parent.Parent.React)

local updateReducer = function(num: number)
	return (num + 1) % 1_000_000
end

--[=[
	@within Hooks

	Forcefully re-renders a component.

	@return () -> () -- Returns an `update` function that forces a re-render when called.
]=]
local function useForceUpdate()
	local _, update = React.useReducer(updateReducer, 0)
	return update
end

return useForceUpdate
