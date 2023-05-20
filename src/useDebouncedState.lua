local React = require(script.Parent.Parent.React)
local JSTimers = require(script.Parent.Parent.Timers)

local useUnmountEffect = require(script.Parent.useUnmountEffect)

--[=[
	@within Hooks

	Allows you to debounce value changes. This can be useful when you need to perform a heavy operation
	based on React state, such as a search request. It is designed to work with controlled components.

	@param initialValue -- The state to start with
	@param debounce -- The time before the state is changed.
	@return (T, (value: T) -> ())
]=]
local function useDebouncedState<T>(initialValue: T, debounce: number, options: { leading: boolean })
	local value, setValue = React.useState(initialValue)
	local timeoutRef = React.useRef(nil)
	local leadingRef = React.useRef(false)

	local function clearTimeout()
		JSTimers.clearTimeout(timeoutRef.current)
	end

	useUnmountEffect(clearTimeout)

	local function debouncedSetValue(newValue: T)
		clearTimeout()

		if not leadingRef.current and options.leading then
			setValue(newValue)
		else
			timeoutRef.current = JSTimers.setTimeout(function()
				leadingRef.current = true
				setValue(newValue)
			end, debounce)
		end

		leadingRef.current = false
	end

	return value, debouncedSetValue
end

return useDebouncedState
