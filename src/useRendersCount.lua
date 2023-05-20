local React = require(script.Parent.Parent.React)

--[=[
	@within Hooks

	Returns the total amount of times a component has re-rendered since it was mounted.
]=]
local function useRendersCount()
	local count = React.useRef(0)
	count.current += 1
	return count.current
end

return useRendersCount
