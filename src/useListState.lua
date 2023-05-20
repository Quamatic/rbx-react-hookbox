local React = require(script.Parent.Parent.React)
local Array = require(script.Parent.Parent.Collections).Array

--[=[
	@interface UseListStateHandlers<T>
	@within Hooks

	.append (T...) -> () -- Appends items to end of the list
	.prepend (T...) -> () -- Adds items to the start of the list
	.insert (index: number, T...) -> () -- Inserts items to the list, starting from `index`
	.apply (fn: (item: T, index: number?) -> T) -> () -- Applies a function to each element of the list
	.remove (...number) -> () -- Removes items at certain positions
	.pop () -> () -- Removes the last item from the list
	.shift () -> () -- Removes the first item from the list
	.reorder (data: { from: number, to: number }) -> () -- Moves items from one position to another
	.applyWhere (condition: (item: T, index: number?) -> boolean, fn: (item: T, index: number?) -> T) -- Applies a function to each element of the list that matches `condition`
	.setItem (index: number, item: T) -> () -- Replaces an item at given index
	.setItemProp (index: number, prop: string, value: T) -> () -- Sets an item's property at given index
	.filter (fn: (item: T, index: number) -> boolean) -> () -- Sets the list based on the items that passed the filter
]=]

--[=[
	@within Hooks

	Hook that allows you to manage list state, without any special utilities.

	@return UseListStateHandlers<T>
]=]
local function useListState<T>(initialValue: { T })
	initialValue = initialValue or {}

	local state, setState = React.useState(initialValue)

	local function append(...: T)
		local values = { ... }
		setState(function(current)
			return Array.concat(current, values)
		end)
	end

	local function prepend(...: T)
		local values = { ... }
		setState(function(current)
			return Array.concat(values, current)
		end)
	end

	local function insert(index: number, ...: T)
		local values = { ... }
		setState(function(current)
			return Array.concat(Array.slice(current, 1, index), values, Array.slice(current, index))
		end)
	end

	local function apply(fn: (item: T, index: number?) -> T)
		setState(function(current)
			return Array.map(current, function(item, index)
				return fn(item, index)
			end)
		end)
	end

	local function remove(...: number)
		local indices = { ... }
		setState(function(current)
			return Array.filter(current, function(_, index)
				return not Array.includes(indices, index)
			end)
		end)
	end

	local function pop()
		setState(function(current)
			local cloned = table.clone(current)
			cloned[#cloned] = nil
			return cloned
		end)
	end

	local function shift()
		setState(function(current)
			local cloned = table.clone(current)
			Array.shift(cloned)
			return cloned
		end)
	end

	local function reorder(data: { from: number, to: number })
		local from, to = data.from, data.to

		setState(function(current)
			local cloned = table.clone(current)
			local item = current[from]

			Array.splice(cloned, from, 1)
			Array.splice(cloned, to, 1, item)

			return cloned
		end)
	end

	local function setItem(index: number, item: T)
		setState(function(current)
			local cloned = table.clone(current)
			cloned[index] = item
			return cloned
		end)
	end

	local function setItemProp(index: number, prop: string, value: T)
		setState(function(current)
			local cloned = table.clone(current)
			cloned[index] = Array.concat(cloned[index], { [prop] = value })
			return cloned
		end)
	end

	local function applyWhere(condition: (item: T, index: number) -> boolean, fn: (item: T, index: number?) -> T)
		setState(function(current)
			return Array.map(current, function(item, index)
				return if condition(item, index) then fn(item, index) else item
			end)
		end)
	end

	local function filter(fn: (item: T, index: number) -> boolean)
		setState(function(current)
			return Array.filter(current, fn)
		end)
	end

	return state,
		{
			setState = setState,
			append = append,
			prepend = prepend,
			insert = insert,
			pop = pop,
			shift = shift,
			apply = apply,
			applyWhere = applyWhere,
			remove = remove,
			reorder = reorder,
			setItem = setItem,
			setItemProp = setItemProp,
			filter = filter,
		}
end

return useListState
