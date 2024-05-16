local Functions = {}

local runService = game:GetService("RunService")

local wsFolder = workspace:WaitForChild("Drones-WS")
local rsFolder = game.ReplicatedStorage:WaitForChild("Drones-RS")

local Globals = require(script.Parent.Globals)
local Lerp = require(script.Parent.Lerp)

local Time = {
	MoveDrone = {},
	MoveModel = {},
	RotateModel = {}
}

local Renders = {
	Orbit = {}
}

function Functions.GetDrones()
	return Globals.Drones
end

function Functions.GetDronesCount()
	return #Globals.Drones
end

function Functions.GetDrone(dronId)
	return Globals.Drones[dronId]
end

function Functions.GetFigures()
	return Globals.Figures
end

function Functions.GetFigure(name)
	return Globals.Figures[name]
end

function Functions.GetCurrentFigure()
	return Globals.Figure
end

function Functions.GetMainModel()
	return Globals.Model
end

function Functions.GetModels()
	return Globals.Models
end

function Functions.GetModel(modelId)
	return Globals.Models[modelId]
end

function Functions.SetCurrentFigure(name)
	Globals.Figure = name
end

function Functions.SetModels(models)
	for k,v in pairs(Globals.Models) do
		v:Destroy()
	end
	
	Globals.Models = {}
	
	for k,v in pairs(models) do
		Globals.Models[k] = v
	end
end

function Functions.SetTransparency(value)
	Globals.Transparency = value
end

function Functions.SetColor(color)
	Globals.Color = color
end

function Functions.GetId(input)
	input = input:gsub("group", "")
	input = input:gsub("model", "")
	input = input:gsub(" ", "")
	input = input:gsub("-", "")
	input = tonumber(input)
	
	return input
end

function Functions.IsSomeoneDroneMoving()
	for k,v in pairs(Globals.DronesMoving) do
		if (v == true) then
			return true
		end
	end
	
	return false
end

function Functions.SpawnDron(dronId, group) 
	if (Globals.Drones[dronId]) then
		Globals.Drones[dronId].Group.Value = group
		return {id = dronId, model = Globals.Drones[dronId]}
	end

	local drone = rsFolder.Drone.Model:Clone()
	drone.Parent = wsFolder.Drones
	drone.Name = "Drone"
	drone.Position = Vector3.new(rsFolder.Drone.Spawn.Position.X + math.random(-rsFolder.Drone.Spawn.Size.X/2, rsFolder.Drone.Spawn.Size.X/2), rsFolder.Drone.Spawn.Position.Y, rsFolder.Drone.Spawn.Position.Z + math.random(-rsFolder.Drone.Spawn.Size.Z/2, rsFolder.Drone.Spawn.Size.Z/2))
	drone.Orientation = rsFolder.Drone.Spawn.Orientation
	drone.Transparency = Globals.Transparency
	drone.Color = Globals.Color
	
	local value = Instance.new("IntValue")
	value.Name = "Group"
	value.Parent = drone
	value.Value = group
	
	Globals.Drones[dronId] = drone

	return {id = dronId, model = drone}
end

function Functions.DeleteDron(dronId)
	if (Globals.Drones[dronId] == nil) then return end
	
	Globals.Drones[dronId]:Destroy()
	Globals.Drones[dronId] = nil
end

function Functions.CreateModel(modelId)
	local  model = Instance.new("Model")
	model.Parent = Globals.Model
	model.Name = "Group-"..modelId

	local centerPart = Instance.new("Part")
	centerPart.Parent = model
	centerPart.Name = "Center"
	centerPart.Transparency = 1
	centerPart.CanCollide = false
	centerPart.CanTouch = false
	centerPart.CanQuery = false
	centerPart.Anchored = true
	centerPart.Position = model:GetBoundingBox().Position

	return model
end

function Functions.MoveDrone(drone, cframe, speed, isGlobal)
	Globals.DronesMoving[drone.id] = true
	
	local droneCFrame = drone.model.CFrame
	local droneEndCFrame = droneCFrame * cframe

	if (isGlobal) then
		droneEndCFrame = cframe
	end
	
	if (speed == 0) then
		drone.model.CFrame = droneEndCFrame
		
		local center = drone.model.Parent
		if (center) then
			--Is bugged
			--local mainCenter = drone.model.Parent.Parent
			--if (mainCenter) then
			--	mainCenter = mainCenter:FindFirstChild("Main-Center")
			--	if (mainCenter) then
			--		mainCenter.Position = mainCenter.Parent:GetBoundingBox().Position
			--	end
			--end
			
			center = center:FindFirstChild("Center")
			if (center) then
				center.Position = center.Parent:GetBoundingBox().Position
			end
		end
		
		Globals.DronesMoving[drone.id] = false
		
		return
	end
	
	local LerpSettings = {
		LerpTime = speed or Globals.Speed,
		Start = drone.model.CFrame,
		End = droneEndCFrame,
		Accelerate = true,
		Decelerate = true,
	}	
	
	local TimeLocal = tick()
	Time.MoveDrone[drone.id] = TimeLocal
	
	local lerp = Lerp.newCframe(LerpSettings)

	task.spawn(function()
		while (not lerp.ended) do
			if Time.MoveDrone[drone.id] ~= TimeLocal or drone.model == nil then
				break
			end

			drone.model.CFrame = lerp.value.CFrame
			
			local center = drone.model.Parent
			if (center) then
				--Is bugged
				--local mainCenter = center.Parent
				--if (mainCenter) then
				--	mainCenter = mainCenter:FindFirstChild("Main-Center")
				--	if (mainCenter) then
				--		mainCenter.Position = mainCenter.Parent:GetBoundingBox().Position
				--	end
				--end
				
				center = center:FindFirstChild("Center")
				if (center) then
					center.Position = center.Parent:GetBoundingBox().Position
				end
			end

			task.wait()
		end
		
		Globals.DronesMoving[drone.id] = false
	end)
end

local moveM = {}
function Functions.MoveModel(model, cframe, speed, isGlobal)
	if (Functions.IsSomeoneDroneMoving()) then
		return
	end
	
	local modelCFrame = model.model:GetPivot()
	local modelEndCFrame = modelCFrame * cframe
	
	if (isGlobal) then
		modelEndCFrame = cframe
	end
	
	if (moveM[model.model] == nil) then
		moveM[model.model] = modelCFrame
	end
	
	local LerpSettings = {
		LerpTime = speed or Globals.Speed,
		Start = modelCFrame,
		End = modelEndCFrame,
		Accelerate = true,
		Decelerate = true,
	}	

	local TimeLocal = tick()
	Time.MoveModel[model.id] = TimeLocal

	local lerp = Lerp.newCframe(LerpSettings)

	task.spawn(function()
		while (not lerp.ended) do
			if Time.MoveModel[model.id] ~= TimeLocal or model.model == nil then
				break
			end

			model.model:PivotTo(lerp.value.CFrame)

			task.wait()
		end
	end)
end

function Functions.RotateModel(model, x, y, z, speed)
	if (Functions.IsSomeoneDroneMoving()) then
		return
	end
	
	local TimeLocal = tick()
	Time.RotateModel[model.id] = TimeLocal

	local modelCFrame = model.model:GetPivot()
	
	local LerpSettings = {
		LerpTime = speed or Globals.Speed,
		Start = modelCFrame,
		End = CFrame.new(modelCFrame.X, modelCFrame.Y, modelCFrame.Z) * CFrame.Angles(math.rad(x), math.rad(y), math.rad(z)),
		Accelerate = true,
		Decelerate = true,
	}

	local lerp = Lerp.newCframe(LerpSettings)

	task.spawn(function()
		while (not lerp.ended) do
			if Time.RotateModel[model.id] ~= TimeLocal or model.model == nil then
				break
			end

			model.model:PivotTo(lerp.value.CFrame)

			task.wait()
		end
	end)
end

function Functions.OrbitModel(model, xSpeed, ySpeed, zSpeed)	
	if (Functions.IsSomeoneDroneMoving()) then
		return
	end
	
	if (Renders.Orbit[model.id]) then
		Renders.Orbit[model.id]:disconnect()
	end

	Renders.Orbit[model.id] = runService.RenderStepped:Connect(function()
		model.model:PivotTo(model.model:GetPivot() * CFrame.Angles(xSpeed/1000, ySpeed/1000, zSpeed/1000))
	end)
end

function Functions.CancelMoveDrone(modelId)
	Time.MoveDrone[modelId] = tick()
end

function Functions.CancelMoveModel(modelId)
	Time.MoveModel[modelId] = tick()
end

function Functions.CancelRotateModel(modelId)
	Time.RotateModel[modelId] = tick()
end

function Functions.CancelOrbitModel(modelId)	
	if (Renders.Orbit[modelId]) then
		Renders.Orbit[modelId]:disconnect()
	end
end

return Functions