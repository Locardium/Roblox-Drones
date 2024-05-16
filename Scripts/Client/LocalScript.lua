-- https://github.com/Locardium/Roblox-Drones by Locos_s

local wsFolder = workspace:WaitForChild("Drones-WS")
local rsFolder = game.ReplicatedStorage:WaitForChild("Drones-RS")

local Globals = require(script.Parent.Globals)
local RE = require(script.Parent.RemoteEvent)

local remoteEvent = rsFolder.Events.RemoteEvent
local remoteFunctions = rsFolder.Events.RemoteFunction

local ServerData = remoteFunctions:InvokeServer("GetServerData")

Globals.Speed = ServerData.Speed
Globals.Figures = ServerData.Figures
Globals.Color = ServerData.Color
Globals.Transparency = ServerData.Transparency

Globals.Model = wsFolder.Drones

RE.ChangeFigure(ServerData.Figure, true)

remoteEvent.OnClientEvent:Connect(function(func, ...)
	for k,v in pairs(RE) do
		if (func == k) then v(...) end
	end
end)