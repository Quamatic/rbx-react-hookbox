local React = require(script.Parent.Parent.React)

--[=[
	@interface UseCounterHandlers
	@within Hooks

	.increment () -> () -- Increments the counter by `1`
	.decrement () -> () -- Decrements the counter by `1`
	.set (value: number) -> () -- Sets the counter to `value`
	.reset () -> () -- Resets the counter back to `0`
]=]

--[=[
	@within Hooks

	Hook that increments/decrements state within given boundaries

	@return (number, UseCounterHandlers) -- The current counter, and the counter handlers.
]=]
local function useCounter()
	local count, setCount = React.useState(0)

	local increment = React.useCallback(function()
		setCount(function(previousCount)
			return previousCount + 1
		end)
	end, {})

	local decrement = React.useCallback(function()
		setCount(function(previousCount)
			return previousCount - 1
		end)
	end, {})

	local set = React.useCallback(function(value: number)
		setCount(value)
	end, {})

	local reset = React.useCallback(function()
		setCount(0)
	end, {})

	return count, {
		increment = increment,
		decrement = decrement,
		set = set,
		reset = reset,
	}
end

return useCounter
