local React = require(script.Parent.Parent.React)

local useEvent = require(script.Parent.useEvent)

--[=[
	@within Hooks

	Returns the current value of an attribute on an instance.

	@param instance -- The instance to use
	@param attribute -- The attribute to observe
	@param defaultValue -- The default value to use if the requested attribute does not exist
	@return T
]=]
local function useAttribute<T>(instance: Instance, attribute: string, defaultValue: T)
	local value, setValue = React.useState(function()
		return instance:GetAttribute(attribute) or defaultValue
	end)

	useEvent(instance:GetAttributeChangedSignal(attribute), function()
		setValue(instance:GetAttribute(attribute))
	end)

	return value
end

return useAttribute
