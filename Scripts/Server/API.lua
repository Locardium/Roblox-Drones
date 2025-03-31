local API = {}

local MainFolder = script.Parent
local rsFolder = game.ReplicatedStorage:WaitForChild("Drones-RS")
local sssFolder = game.ServerScriptService:WaitForChild("Drones-SSS")

local RemoteEvent = rsFolder.Events.RemoteEvent

local Globals = require(sssFolder.Globals)

function API.GetFiguresName()
	local figures = {}
	local count = 1
	for k,v in pairs(Globals.Figures) do
		figures[count] = k
		count += 1
	end
	
	return figures
end

function API.GetCurrentFigureName()
	return Globals.Figure
end

function API.GetTotalDrones()
	return Globals.Drones
end

function API.ChangeFigure(figureName) 
	if (Globals.Figures[figureName] == nil) then return end
	
	Globals.Figure = figureName
	
	local totalDrones = 0
	for k,v in pairs(Globals.Figures[figureName]) do
		if (v.CFrame ~= nil) then
			totalDrones = #Globals.Figures[figureName]
			break
		end
		totalDrones += #v
	end
	Globals.Drones = totalDrones

	RemoteEvent:FireAllClients("ChangeFigure", figureName, false)
end

function API.MoveDrones(modelId, x, y, z, speed, isGlobal)
	if (modelId ~= nil) then
		if (typeof(modelId) ~= "number") then 
			if (typeof(modelId) == "string") then
				modelId = modelId:lower()
				if (modelId ~= "all" and modelId ~= "joint") then
					return
				end
			else return end
		end
	else modelId = "all" end
	if ((typeof(x) ~= "number")  or (typeof(y) ~= "number") or (typeof(z) ~= "number")) then return end
	if (typeof(speed) ~= "number" and speed ~= nil) then return end

	RemoteEvent:FireAllClients("MoveDrones", modelId, x, y, z, speed, isGlobal)
end

function API.RotateDrones(modelId, x, y, z, speed)
	if (modelId ~= nil) then
		if (typeof(modelId) ~= "number") then 
			if (typeof(modelId) == "string") then
				modelId = modelId:lower()
				if (modelId ~= "all" and modelId ~= "joint") then
					return
				end
			else return end
		end
	else modelId = "all" end
	if ((typeof(x) ~= "number")  or (typeof(y) ~= "number") or (typeof(z) ~= "number")) then return end
	if (typeof(speed) ~= "number" and speed ~= nil) then return end

	RemoteEvent:FireAllClients("RotateDrones", modelId, x, y, z, speed)
end

function API.OrbitDrones(modelId, xSpeed, ySpeed, zSpeed)
	if (modelId ~= nil and modelId ~= "all" and modelId ~= "joint" and typeof(modelId) ~= "number") then return end
	if ((typeof(xSpeed) ~= "number")  or (typeof(ySpeed) ~= "number") or (typeof(zSpeed) ~= "number")) then return end

	RemoteEvent:FireAllClients("OrbitDrones", modelId, xSpeed, ySpeed, zSpeed)
end

function API.CancelMove(modelId)
	if (modelId ~= nil) then
		if (typeof(modelId) ~= "number") then 
			if (typeof(modelId) == "string") then
				modelId = modelId:lower()
				if (modelId ~= "all" and modelId ~= "joint") then
					return
				end
			else return end
		end
	else modelId = "all" end

	RemoteEvent:FireAllClients("CancelMove", modelId)
end

function API.CancelRotate(modelId)
	if (modelId ~= nil) then
		if (typeof(modelId) ~= "number") then 
			if (typeof(modelId) == "string") then
				modelId = modelId:lower()
				if (modelId ~= "all" and modelId ~= "joint") then
					return
				end
			else return end
		end
	else modelId = "all" end

	RemoteEvent:FireAllClients("CancelRotate", modelId)
end

function API.CancelOrbit(modelId)
	if (modelId ~= nil) then
		if (typeof(modelId) ~= "number") then 
			if (typeof(modelId) == "string") then
				modelId = modelId:lower()
				if (modelId ~= "all" and modelId ~= "joint") then
					return
				end
			else return end
		end
	else modelId = "all" end

	RemoteEvent:FireAllClients("CancelOrbit", modelId)
end

function API.SetColor(dronId, color)
	if (dronId ~= nil) then
		if (typeof(dronId) ~= "number") then
			if (typeof(dronId) == "string") then
				dronId = dronId:lower()
				if (dronId ~= "all" and not dronId:find("group") and not dronId:find("model")) then
					return
				end
			else return end
		end
	else dronId = "all" end
	if (typeof(color) ~= "Color3") then return end

	if (dronId == nil or dronId:lower() == "all") then
		Globals.Color = color
	end

	RemoteEvent:FireAllClients("SetColor", dronId, color)
end

function API.SetTransparency(dronId, transparency)
	if (dronId ~= nil) then
		if (typeof(dronId) ~= "number") then
			if (typeof(dronId) == "string") then
				dronId = dronId:lower()
				if (dronId ~= "all" and not dronId:find("group") and not dronId:find("model")) then
					return
				end
			else return end
		end
	else dronId = "all" end
	if (typeof(transparency) == "number" and transparency >= 1 and transparency <= 0) then return end

	if (dronId == nil or dronId == "all") then
		Globals.Transparency = transparency
	end

	RemoteEvent:FireAllClients("SetTransparency", dronId, transparency)
end

function API.Reset() 
	Globals.Figure = nil
	Globals.Drones = 0
	Globals.Color = Globals.Default.Color
	Globals.Transparency = Globals.Default.Transparency

	RemoteEvent:FireAllClients("Reset", Globals.Default)
end

return API
