local React = require(script.Parent.Parent.React)

--[=[
	@within Hooks

	Hook that allows you to get the previous value of a state.
]=]
local function usePrevious<T>(state: T): T?
	local previous = React.useRef(nil) :: { current: T? }

	React.useEffect(function()
		previous.current = state
	end, { state })

	return previous.current
end

return usePrevious
