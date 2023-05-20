local React = require(script.Parent.Parent.React)
local JSTimers = require(script.Parent.Parent.Timers)

local useMountedState = require(script.Parent.useMountedState)
local useUnmountEffect = require(script.Parent.useUnmountEffect)

local function useDebouncedValue<T>(value: T, debounce: number, leading: boolean?)
	local _value, setValue = React.useState(value)
	local timeoutRef = React.useRef(nil)
	local cooldownRef = React.useRef(nil)
	local isMounted = useMountedState()

	local function cancel()
		JSTimers.clearTimeout(timeoutRef.current)
	end

	React.useEffect(function()
		if not isMounted() then
			return
		end

		if not cooldownRef.current and leading then
			cooldownRef.current = true
			setValue(value)
		else
			cancel()
			timeoutRef.current = JSTimers.setTimeout(function()
				cooldownRef.current = false
				setValue(value)
			end, debounce)
		end
	end, { value, debounce, leading })

	useUnmountEffect(cancel)

	return _value, cancel
end

return useDebouncedValue
