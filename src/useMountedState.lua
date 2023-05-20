local React = require(script.Parent.Parent.React)

--[=[
	@within Hooks

	Lifecycle hook providing ability to check component's mount state.

	@return () -> boolean -- Callback that returns the components mounted state.
]=]
local function useMountedState()
	local mounted = React.useRef(false)

	local get = React.useCallback(function()
		return mounted.current
	end, {})

	React.useEffect(function()
		mounted.current = true

		return function()
			mounted.current = false
		end
	end, {})

	return get
end

return useMountedState
