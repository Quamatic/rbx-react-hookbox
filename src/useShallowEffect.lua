local React = require(script.Parent.Parent.React)

local function shallowEqual(a: any, b: any)
	if a == b then
		return true
	end

	if typeof(a) ~= "table" or typeof(b) ~= "table" then
		return false
	end

	if #a ~= #b then
		return false
	end

	for key, value in a do
		if not shallowEqual(value, b[key]) then
			return false
		end
	end

	return true
end

local function useShallowCompare(deps: { any })
	local ref = React.useRef({})
	local updateRef = React.useRef(0)

	if not shallowEqual(ref.current, deps) then
		ref.current = deps
		updateRef.current += 1
	end

	return { ref.current }
end

--[[
    @within Hooks

	Replacement for `useEffect` that shallow compares dependencies
]]
local function useShallowEffect(fn: () -> (), deps: { any })
	React.useEffect(fn, useShallowCompare(deps))
end

return useShallowEffect
