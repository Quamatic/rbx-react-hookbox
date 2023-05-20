local React = require(script.Parent.Parent.React)

export type QueueMethods<T> = {
	add: (T...) -> (),
	remove: () -> T,
	clear: () -> (),
	first: T,
	last: T,
	size: number,
}

--[=[
	@interface UseQueue<T>
	@within Hooks

	.add (...: T...) -> () -- Adds items to the queue
	.remove () -> () -- Shifts the first item out of the queue
	.clear () -> () -- Clears all items out of the queue
	.first T? -- The first item of the queue
	.last T? -- The last item of the queue
	.size number -- The amount of items inside the queue
]=]

--[=[
	@within Hooks

	Allows you to use a simple FIFO queue, without any special utility required.
	Adding and removing items automatically mutates the state, and performs a re-render.

	@return UseQueue<T>
]=]
local function useQueue<T>(initialValue: { T }): QueueMethods<T>
	initialValue = initialValue or {} :: { T }

	local state, set = React.useState(initialValue)

	local function add<T...>(...: T...)
		local packed = table.pack(...)

		set(function(queue)
			queue = table.clone(queue)
			table.move(packed, 1, packed.n, #queue + 1, queue)
			return queue
		end)
	end

	local function remove()
		local result

		set(function(queue)
			queue = table.clone(queue)
			result = table.remove(queue, 1)
			return queue
		end)

		return result
	end

	local function clear()
		set({})
	end

	local methods: QueueMethods<T> = React.useMemo(function()
		return {
			add = add,
			remove = remove,
			clear = clear,
			first = state[1],
			last = state[#state],
			size = #state,
		}
	end, { add, remove, clear, state })

	return methods
end

return useQueue
