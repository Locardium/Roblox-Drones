local scriptsFolder = script.Parent

--Workspace
local mainFolder = script.Parent.Parent
mainFolder.Parent = workspace
mainFolder.Name = "Drones-WS"

local dronesModel = Instance.new("Model")
dronesModel.Parent = mainFolder
dronesModel.Name = "Drones"

--Is bugged
--local centerPart = Instance.new("Part")
--centerPart.Parent = dronesModel
--centerPart.Name = "Main-Center"
--centerPart.Transparency = 1
--centerPart.CanCollide = false
--centerPart.CanTouch = false
--centerPart.CanQuery = false
--centerPart.Anchored = true
--centerPart.Position = dronesModel:GetBoundingBox().Position

--Replicated Storage
local rsFolder = Instance.new("Folder")
rsFolder.Parent = game.ReplicatedStorage
rsFolder.Name = "Drones-RS"

mainFolder.Drone.Parent = rsFolder
scriptsFolder.Events.Parent = rsFolder

--Starter Player Scripts
local SPS = scriptsFolder.Client
SPS.Parent = game.StarterPlayer.StarterPlayerScripts
SPS.Name = "Drones-SPS"

--Server Storage
local ssFolder = Instance.new("Folder")
ssFolder.Parent = game.ServerStorage
ssFolder.Name = "Drones-SS"

scriptsFolder.Server.API.Parent = ssFolder

--Server Script Service
local sssFolder = scriptsFolder.Server
sssFolder.Parent = game.ServerScriptService
sssFolder.Name = "Drones-SSS"

--Load Figures
local Global = require(sssFolder.Globals)

for k,v in pairs(mainFolder.Figures:GetChildren()) do
	for k2,v2 in pairs(v:GetChildren()) do
		if v2:IsA("Part") then
			Global.Figures[v.Name] = Global.Figures[v.Name] or {}
			Global.Figures[v.Name][k2] = {CFrame = v2.CFrame, Group = v2.Group.Value}
		elseif v2:IsA("Folder") then
			if (tonumber(v2.Name) == nil) then warn("Invalid name, only int numbers. Current Name:", v2)continue end
			
			for k3,v3 in pairs(v2:GetChildren()) do
				if v3:IsA("Part") then
					Global.Figures[v.Name] = Global.Figures[v.Name] or {}
					Global.Figures[v.Name][tonumber(v2.Name)] = Global.Figures[v.Name][tonumber(v2.Name)] or {}
					Global.Figures[v.Name][tonumber(v2.Name)][k3] = {CFrame = v3.CFrame, Group = v3.Group.Value}
				end
			end
		end
	end

	v:Destroy()
end

--Set Defaults
Global.Default = {
	Transparency = Global.Transparency,
	Color = Global.Color
}

task.wait()
script.Parent = mainFolder

if (#mainFolder.Scripts:GetChildren() == 0) then
	mainFolder.Scripts:Destroy()
end

script:Destroy()