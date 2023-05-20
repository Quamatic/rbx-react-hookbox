-- @diagnostic disable: deprecated
local React = require(script.Parent.Parent.React)

type SignalLike = RBXScriptSignal | {
	Connect: () -> (),
} | {
	connect: () -> (),
} | {
	on: () -> (),
} | (() -> ())

type SignalLikeConnection = RBXScriptConnection | {
	Destroy: () -> (),
} | {
	destroy: () -> (),
} | {
	disconnect: () -> (),
} | {
	Disconnect: () -> (),
} | (() -> ())

local VALID_CONNECTION_NAMES = { "Connect", "connect", "on" }
local VALID_DISCONNECT_NAMES = { "Disconnect", "disconnect", "Destroy", "destroy" }

local function connect(event: SignalLike, callback: () -> ())
	if typeof(event) == "function" then
		return event(callback)
	elseif typeof(event) == "RBXScriptSignal" then
		return event:Connect(callback)
	elseif typeof(event) == "table" then
		for _, name in VALID_CONNECTION_NAMES do
			if type(event[name]) == "function" then
				return event[name](event, callback)
			end
		end
	end

	error(
		`Invalid event passed: {typeof(event)}. No valid connections were found.`
			.. `The valid connection types are \n1) A function\n2) A RBXScriptSignal\n3) A table with one of these methods: {table.concat(
				VALID_CONNECTION_NAMES,
				", "
			)}`
	)
end

local function disconnect(connection: SignalLikeConnection)
	if type(connection) == "function" then
		connection()
		return
	end

	for _, method in VALID_DISCONNECT_NAMES do
		if type(connection[method]) == "function" then
			connection[method](connection)
			break
		end
	end
end

--[=[
	@within Hooks

	Connects an event that has a signal-like connection, and disconnects the event on unmount.

	@tag event
	@param event -- The connection to use
	@param callbackFn -- The function to be called when the signal fires
]=]
local function useEvent<T...>(event: SignalLike, callbackFn: (T...) -> ())
	local callbackRef = React.useRef(callbackFn)

	React.useEffect(function()
		local connection = connect(event, callbackRef.current)

		return function()
			disconnect(connection)
		end
	end, { callbackRef.current })
end

return useEvent
