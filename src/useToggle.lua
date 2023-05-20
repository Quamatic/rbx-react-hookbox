local React = require(script.Parent.Parent.React)

--[=[
	@within Hooks

	Switches between given values. Indice overflow is prevented.

	@return (T, () -> ()) -- The current option, and the toggle function for going to the next option.
]=]
local function useToggle<T>(options: { T })
	if #options < 2 then
		error("At least 2 options should be provided")
	end

	local value, setValue = React.useState(options[1])

	local toggle = React.useCallback(function()
		setValue(function(previousValue: T)
			local index = table.find(options, previousValue)
			local nextSelectionIndex = index % #options + 1

			return options[nextSelectionIndex]
		end)
	end, {})

	return value, toggle
end

return useToggle
