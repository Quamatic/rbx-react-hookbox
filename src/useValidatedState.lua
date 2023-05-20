local React = require(script.Parent.Parent.React)

--[=[
	@interface UseValidatedStateValues<T>
	@within Hooks

	.value T -- The current raw value
	.lastValidValue T? -- The current value after being validated
	.valid boolean -- Whether the current state is valid or not
]=]

--[=[
	@within Hooks

	Allows you to handle state that can be validated against.

	@param initialValue -- The value to start with
	@param validation -- The validation function
	@return (UseValidatedStateValues<T>, (value: T) -> ()) -- The validated state values, and the `onChange` handler.
]=]
local function useValidatedState<T>(initialValue: T, validation: (value: T) -> boolean, initialValidationState: T?)
	local value, setValue = React.useState(initialValue)
	local lastValidValue, setLastValidValue = React.useState(if validation(initialValue) then initialValue else nil)
	local valid, setValid = React.useState(
		if typeof(initialValidationState) == "boolean" then initialValidationState else validation(initialValue)
	)

	local onChange = React.useCallback(function(val: T)
		if validation(val) then
			setLastValidValue(val)
			setValid(true)
		else
			setValid(false)
		end

		setValue(val)
	end, {})

	return {
		value = value,
		lastValidValue = lastValidValue,
		valid = valid,
	}, onChange
end

return useValidatedState
