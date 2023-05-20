local React = require(script.Parent.Parent.React)
local Object = require(script.Parent.Parent.Collections).Object

--[=[
	@within Hooks

	Hook that works the same as class components `setState` method. State is by default an object,
	and setting state shallow merges partially into the current.

	@return ({[string]: T}, (statePartial: {[string]: T} | ((currentState: {[string]: T}) -> {[string]: T}))) -- The current state, and the state setter function.
]=]
local function useSetState<T>(initialState: { [string]: T })
	type State = typeof(initialState)

	local state, setStateInternal = React.useState(initialState)
	local setState = React.useCallback(function(statePartial: State | ((currentState: State) -> State))
		setStateInternal(function(current)
			return Object.assign(
				{},
				current,
				if type(statePartial) == "function" then statePartial(current) else statePartial
			)
		end)
	end, {})

	return state, setState
end

return useSetState
