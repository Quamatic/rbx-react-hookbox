local React = require(script.Parent.Parent.React)

local useUpdateEffect = require(script.Parent.useUpdateEffect)

--[=[
	@within Hooks

	Log given values to console when component renders.

	@param componentName -- The component name used when printing into the output
	@param ... -- The values to print out when required
]=]
local function useLogger(componentName: string, ...: any)
	local rest = React.useRef({ ... })

	React.useEffect(function()
		print(componentName, "mounted", unpack(rest.current))

		return function()
			print(componentName, "unmounted")
		end
	end, {})

	useUpdateEffect(function()
		print(componentName, "updated", unpack(rest.current))
	end)
end

return useLogger
