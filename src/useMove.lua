local React = require(script.Parent.Parent.React)

--[=[
    @within Hooks

    Handles move behavior over any element. Commonly used to build sliders, color pickers, or any other element
    that requires dragging.
]=]
local function useMove()
	local ref = React.useRef(nil)

	return ref
end

return useMove
