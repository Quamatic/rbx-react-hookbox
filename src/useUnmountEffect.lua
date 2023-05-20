local React = require(script.Parent.Parent.React)

--[=[
	@within Hooks

	Shorthand hook that allows you to only perform an unmount effect.
]=]
local function useUnmountEffect<T...>(cleanup: (T...) -> ())
	React.useEffect(function()
		return cleanup
	end, {})
end

return useUnmountEffect
