local ES7Types = require(script.Parent.Parent.ES7Types)
type Function = ES7Types.Function

local React = require(script.Parent.Parent.React)
local JSTimers = require(script.Parent.Parent.Timers)

local function useTimeout<T...>(callback: (T...) -> (), delay: number, autoInvoke: boolean?)
	local callbackRef = React.useRef(nil) :: { current: Function }
	local timeoutRef = React.useRef(nil) :: { current: number }

	local start = React.useCallback(function(...: T...)
		local callbackParams = { ... }

		if not timeoutRef.current then
			timeoutRef.current = JSTimers.setTimeout(function()
				callbackRef.current(unpack(callbackParams))
				timeoutRef.current = nil
			end, delay)
		end
	end, { delay })

	local clear = React.useCallback(function()
		if timeoutRef.current then
			JSTimers.clearTimeout(timeoutRef.current)
			timeoutRef.current = nil
		end
	end, {})

	React.useEffect(function()
		callbackRef.current = callback
	end, { callback })

	React.useEffect(function()
		if autoInvoke then
			start()
		end

		return clear
	end, { clear, delay, start, autoInvoke })

	return {
		start = start,
		clear = clear,
	}
end

return useTimeout
