local React = require(script.Parent.Parent.React)
local JSTimers = require(script.Parent.Parent.Timers)

--[=[
	@interface UseInterval
	@within Hooks

	.start () -> ()
	.stop () -> ()
	.toggle () -> ()
	.active boolean
]=]

--[=[
	@within Hooks

	Used as a wrapper around `setInterval`.

	@param fn -- The function to call when the interval is triggered
	@param interval -- The time between each interval
	@return UseInterval
]=]
local function useInterval(fn: () -> (), interval: number)
	local active, setActive = React.useState(false)
	local intervalRef = React.useRef() :: { current: number }
	local fnRef = React.useRef() :: { current: () -> () }

	React.useEffect(function()
		fnRef.current = fn
	end, { fn })

	local start = React.useCallback(function()
		setActive(function(old)
			if not old and not intervalRef.current then
				intervalRef.current = JSTimers.setInterval(fnRef.current, interval)
			end

			return true
		end)
	end, {})

	local stop = React.useCallback(function()
		setActive(false)
		JSTimers.clearInterval(intervalRef.current)
		intervalRef.current = nil
	end, {})

	local toggle = React.useCallback(function()
		if active then
			stop()
		else
			start()
		end
	end, { active })

	return {
		start = start,
		stop = stop,
		toggle = toggle,
		active = active,
	}
end

return useInterval
