local React = require(script.Parent.Parent.React)

--[=[
	@interface UseDisclosureHandlers
	@within Hooks

	.open () -> () -- Sets the boolean state to `true`
	.close () -> () -- Sets the boolean state to `false`
	.toggle () -> () -- Toggles the boolean state
]=]

--[=[
	@within Hooks

	Hook that manages boolean state

	@return (boolean, UseDisclosureHandlers) -- The current state, and the disclosure handlers.
]=]
local function useDisclosure(initialState: boolean)
	local opened, setOpened = React.useState(initialState)

	local function open()
		setOpened(true)
	end

	local function close()
		setOpened(false)
	end

	local function toggle()
		setOpened(not opened)
	end

	return opened, {
		open = open,
		close = close,
		toggle = toggle,
	}
end

return useDisclosure
