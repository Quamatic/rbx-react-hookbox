local React = require(script.Parent.Parent.React)
local Array = require(script.Parent.Parent.Collections).Array

local useUncontrolled = require(script.Parent.useUncontrolled)

type PaginationParams = {
	total: number,
	initialPage: number?,
	page: number?,
	siblings: number?,
	boundaries: number?,
	onChange: (page: number) -> ()?,
}

type PaginationObject = {
	range: { number | "dots" },
	nextPage: () -> (),
	previous: () -> (),
	first: () -> (),
	last: () -> (),
	setPage: (pageNumber: number) -> (),
	active: boolean,
}

local DOTS = "dots"

local function fromRange(start: number, end_: number)
	local length = end_ - start + 1
	return Array.from({ length = length }, function(_, index)
		return index + start
	end)
end

--[=[
	@interface PaginationParams
	@within Hooks

	.total number -- The total amount of pages
	.initialPage number? -- The page to start from
	.page number? -- The page to use when using outside, controlled state
	.siblings number? -- Controls the amount of active siblings
	.boundaries number? -- Controls the amount of items on each boundary
	.onChange (page: number) -> ()? -- Callback that is called when the current page is changed. Usually used when using outside, controlled state.
]=]

--[=[
	@interface PaginationObject
	@within Hooks

	.range { number | "dots } -- The calculated range between the pages. When an indice is equal to `dots`, that means there is a split between the previous and next page.
	.nextPage () -> () -- Goes to the next page
	.previous () -> () -- Goes to the previous page
	.first () -> () -- Goes to the first page
	.last () -> () -- Goes to the last page
	.setPage (pageNumber: number) -> () -- Goes to a specified page
	.active number -- The currently active page 
]=]

--[=[
	@within Hooks
	@tag controllable

	Hook that allows you to manage pagination state.

	@param params PaginationParams -- The parameters to use
	@return PaginationObject
]=]
local function usePagination(params: PaginationParams)
	local initialPage = params.initialPage or 1
	local siblings = params.siblings or 1
	local boundaries = params.boundaries or 1

	local total = React.useMemo(function()
		return math.max(math.round(params.total), 0)
	end, { params.total })

	local activePage, setActivePage = useUncontrolled({
		value = params.page,
		onChange = params.onChange,
		defaultValue = initialPage,
		finalValue = initialPage,
	})

	local setPage = React.useCallback(function(pageNumber: number)
		if pageNumber <= 0 then
			setActivePage(1)
		elseif pageNumber > total then
			setActivePage(total)
		else
			setActivePage(pageNumber)
		end
	end, {})

	local nextPage = React.useCallback(function()
		setPage(activePage + 1)
	end, { activePage })

	local previous = React.useCallback(function()
		setPage(activePage - 1)
	end, { activePage })

	local first = React.useCallback(function()
		setPage(1)
	end, {})

	local last = React.useCallback(function()
		setPage(total)
	end, { total })

	local range: { number | "dots" } = React.useMemo(function()
		local totalPageNumbers = siblings * 2 + 3 + boundaries * 2
		if totalPageNumbers >= total then
			return fromRange(1, total)
		end

		local leftSiblingIdx = math.max(activePage - siblings, boundaries)
		local rightSiblingIdx = math.max(activePage + siblings, total - boundaries)

		local shouldShowLeftDots = leftSiblingIdx > boundaries + 2
		local shouldShowRightDots = rightSiblingIdx < total - (boundaries + 1)

		-- TODO: replace unpack here, was implemented to quickly mimic the spread operator

		if not shouldShowLeftDots and shouldShowRightDots then
			local leftItemCount = siblings * 2 + boundaries * 2
			return {
				unpack(fromRange(1, leftItemCount)),
				DOTS,
				unpack(fromRange(total - (boundaries - 1), total)),
			}
		end

		if shouldShowLeftDots and not shouldShowRightDots then
			local rightItemCount = boundaries + 1 + 2 * siblings
			return {
				unpack(fromRange(1, boundaries)),
				DOTS,
				unpack(fromRange(total - rightItemCount, total)),
			}
		end

		return {
			unpack(fromRange(1, boundaries)),
			DOTS,
			unpack(fromRange(leftSiblingIdx, rightSiblingIdx)),
			DOTS,
			unpack(fromRange(total - boundaries + 1, total)),
		}
	end, { total, siblings, boundaries })

	return {
		range = range,
		nextPage = nextPage,
		previous = previous,
		setPage = setPage,
		first = first,
		last = last,
		active = activePage,
	} :: PaginationObject
end

return usePagination
