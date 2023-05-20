local React = require(script.Parent.Parent.React)

type UseUncontrolledProps<T> = {
	value: T?,
	finalValue: T?,
	defaultValue: T?,
	onChange: (newValue: T) -> ()?,
}

--[=[
	@interface UseUncontrolledProps<T>
	@within Hooks

	.value T? -- The current value
	.finalValue T? -- The final value when `defaultValue` is not present
	.defaultValue T? -- The default value to use
	.onChange (value: T) -> ()? -- The callback to use when state is changed
]=]

--[=[
	@within Hooks
	@tag controlled

	Allows you to manage state of both controlled and uncontrolled components.
	An `uncontrolled` component is a component that manages its own state, while a `controlled` component uses provided state to perform
	renders off of.

	@return (T, (value: T) -> (), boolean) -- The current value, the state setter function, and whether the state is controlled or not.
]=]
local function useUncontrolled<T>(props: UseUncontrolledProps<T>)
	local value, setValue = React.useState(if props.defaultValue then props.defaultValue else props.finalValue)

	local handleUncontrolledChange = React.useCallback(function(val: T)
		setValue(val)

		if props.onChange then
			props.onChange(val)
		end
	end, {})

	if props.value then
		return props.value, props.onChange, true
	end

	return value, handleUncontrolledChange, false
end

return useUncontrolled
