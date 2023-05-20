local React = require(script.Parent.Parent.React)

local function useUpdateEffect(effect: () -> (), deps: { any })
	local mounted = React.useRef(false)

	React.useEffect(function()
		if not mounted.current then
			mounted.current = true
			return
		end

		effect()
	end, deps)
end

return useUpdateEffect
