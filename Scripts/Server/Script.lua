local rsFolder = game.ReplicatedStorage:WaitForChild("Drones-RS")

local RemoteFunction = rsFolder.Events.RemoteFunction

local RF = require(script.Parent.RemoteFunction)

RemoteFunction.OnServerInvoke = function(Player, Function, ...)
	for k,v in pairs(RF) do
		if (Function == k) then return v(Player, ...) end
	end

	return false
end