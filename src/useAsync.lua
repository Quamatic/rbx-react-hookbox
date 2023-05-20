local React = require(script.Parent.Parent.React)

local useAsyncFn = require(script.Parent.useAsyncFn)

--[=[
	@within Hooks

	Resolves an asynchronous operation **or** a function that returns a Promise.

	@tag promise
	@param fn () -> Promise<T>
	@param deps -- Dependencies that cause the operation to re-resolve
]=]
local function useAsync<T>(fn: () -> T, deps: { any }): T
	local state, callback = useAsyncFn(fn, deps, {
		loading = true,
	})

	React.useEffect(function()
		callback()
	end, { callback })

	return state
end

return useAsync
