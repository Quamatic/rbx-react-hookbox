local React = require(script.Parent.Parent.React)
local Array = require(script.Parent.Parent.Collections).Array

local function assignRef(ref, node)
	if type(ref) == "function" then
		ref(node)
	else
		ref.current = node
	end
end

local function mergeRefs<T>(...: T)
	local refs = { ... }

	return function(node: T?)
		Array.forEach(refs, function(ref)
			assignRef(ref, node)
		end)
	end
end

--[=[
	@within Hooks

	Allows you to use multiple refs for one instance

	@return (Instance) -> () -- The ref function to be passed to React
]=]
local function useMergedRef(...: any)
	return React.useCallback(mergeRefs(...), { ... })
end

return useMergedRef
