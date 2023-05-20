local React = require(script.Parent.Parent.React)
local Object = require(script.Parent.Parent.Collections).Object

local useMountedState = require(script.Parent.useMountedState)

export type AsyncState<T> = {
	loading: boolean,
} | {
	loading: true,
	error: any?,
	value: T?,
} | {
	loading: false,
	error: any,
} | {
	loading: false,
	value: T,
}

local function useAsyncFn<T, Args...>(fn: any, deps: any, initialState: any): (AsyncState<T>, (Args...) -> {})
	deps = deps or {}

	local lastCallId = React.useRef(0)
	local state, setState = React.useState(initialState)
	local isMounted = useMountedState()

	local callback = React.useCallback(function(...: Args...)
		local callId = lastCallId.current
		lastCallId.current += 1

		if not state.loading then
			setState(function(prevState)
				return Object.assign({}, prevState, { loading = true })
			end)
		end

		return fn(...):andThen(function(value)
			if isMounted() and callId == lastCallId.current then
				setState({ value = value, loading = false })
			end

			return value
		end, function(error)
			if isMounted() and callId == lastCallId.current then
				setState({ error = error, loading = false })
			end

			return error
		end)
	end, deps)

	return state, callback
end

return useAsyncFn
