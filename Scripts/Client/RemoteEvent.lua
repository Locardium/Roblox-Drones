local RE = {}

local wsFolder = workspace:WaitForChild("Drones-WS")

local Functions = require(script.Parent.Functions)

function RE.ChangeFigure(figureName, instant)
	local figureData = Functions.GetFigure(figureName)
	if (not figureData) then return end
	
	Functions.SetCurrentFigure(figureName)
	
	RE.CancelAll("all")
	RE.CancelAll("joint")
	
	if (instant == true) then instant = 0 elseif (instant == false or instant ~= typeof("bool")) then instant = nil end
	
	local count = 0

	local model
	local models = {}
	for k,v in pairs(figureData) do
		if (v.CFrame ~= nil) then
			if (model == nil) then
				model = Functions.CreateModel(1)
				models[1] = model
			end
			
			count += 1
			
			local drone = Functions.SpawnDron(k, v.Group)
			drone.model.Parent = model
			
			Functions.MoveDrone(drone, v.CFrame, instant, true)
		else
			model = Functions.CreateModel(k)
			models[k] = model

			for k2,v2 in pairs(v) do
				count = count + 1
				
				local drone = Functions.SpawnDron(count, v2.Group)
				drone.model.Parent = model

				Functions.MoveDrone(drone, v2.CFrame, instant, true)
			end
		end
	end
	
	Functions.SetModels(models)

	if (Functions.GetDronesCount() - count == 0) then return end

	for i = count, (count + (Functions.GetDronesCount() - count)) do
		Functions.DeleteDron(i, true)
	end
end

function RE.MoveDrones(modelId, x, y, z, speed, isGlobal)
	RE.CancelAll(modelId)
	
	if (modelId == "all") then
		local models = Functions.GetModels()

		for k,v in pairs(models) do
			Functions.MoveModel({ id = k, model = v}, CFrame.new(x, y, z), speed, isGlobal)
		end

		return
	elseif (modelId == "joint") then
		Functions.MoveModel({ id = 0, model = Functions.GetMainModel()}, CFrame.new(x, y, z), speed, isGlobal)
		return
	end

	local model = Functions.GetModel(modelId)
	if (not model) then return end

	Functions.MoveModel({ id = modelId, model = model}, CFrame.new(x, y, z), speed, isGlobal)
end

function RE.RotateDrones(modelId, x, y, z, speed)
	RE.CancelAll(modelId)
	
	if (modelId == "all") then
		local models = Functions.GetModels()

		for k,v in pairs(models) do
			Functions.RotateModel({ id = k, model = v}, x, y, z, speed)
		end
		
		return
	elseif (modelId == "joint") then
		Functions.RotateModel({ id = 0, model = Functions.GetMainModel()}, x, y, z, speed)
		return
	end
	
	local model = Functions.GetModel(modelId)
	if (not model) then return end
	
	Functions.RotateModel({ id = modelId, model = model}, x, y, z, speed)
end

function RE.OrbitDrones(modelId, xSpeed, ySpeed, zSpeed)
	RE.CancelAll(modelId)
	
	if (modelId == "all") then
		local models = Functions.GetModels()

		for k,v in pairs(models) do
			Functions.OrbitModel({ id = k, model = v}, xSpeed, ySpeed, zSpeed)
		end

		return
	elseif (modelId == "joint") then
		Functions.OrbitModel({ id = 0, model = Functions.GetMainModel()}, xSpeed, ySpeed, zSpeed)
		return
	end

	local model = Functions.GetModel(modelId)
	if (not model) then return end

	Functions.OrbitModel({ id = modelId, model = model}, xSpeed, ySpeed, zSpeed)
end

function RE.CancelMove(modelId)
	if (modelId == "all") then
		local models = Functions.GetModels()

		for k,v in pairs(models) do
			Functions.CancelMoveModel(k)
		end

		return
	elseif (modelId == "joint") then
		Functions.CancelMoveModel(0)
		return
	end

	local model = Functions.GetModel(modelId)
	if (not model) then return end

	Functions.CancelMoveModel(modelId)
end

function RE.CancelRotate(modelId)
	if (modelId == "all") then
		local models = Functions.GetModels()

		for k,v in pairs(models) do
			Functions.CancelRotateModel(k)
		end

		return
	elseif (modelId == "joint") then
		Functions.CancelRotateModel(0)
		return
	end

	local model = Functions.GetModel(modelId)
	if (not model) then return end

	Functions.CancelRotateModel(modelId)
end

function RE.CancelOrbit(modelId)
	if (modelId == "all") then
		local models = Functions.GetModels()

		for k,v in pairs(models) do
			Functions.CancelOrbitModel(k)
		end

		return
	elseif (modelId == "joint") then
		Functions.CancelOrbitModel(0)
		return
	end

	local model = Functions.GetModel(modelId)
	if (not model) then return end

	Functions.CancelOrbitModel(modelId)
end

function RE.CancelAll(id)
	RE.CancelMove(id)
	RE.CancelRotate(id)
	RE.CancelOrbit(id)
end

function RE.SetTransparency(droneId, value)
	if (droneId == "all") then
		Functions.SetTransparency(value)
		
		for k,v in pairs(Functions.GetDrones()) do
			v.Transparency = value
		end

		return
	end
	
	if typeof(droneId) == "string" then
		if (droneId:find("group")) then
			droneId = Functions.GetId(droneId)
			if (droneId == nil) then return end

			for k,v in pairs(Functions.GetDrones()) do
				if (v.Group.Value == droneId) then
					v.Transparency = value
				end
			end

			return
		elseif (droneId:find("model")) then
			droneId = Functions.GetId(droneId)
			if (droneId == nil) then return end

			local model = Functions.GetModel(droneId)
			if (model == nil) then return end
			for k,v in pairs(Functions.GetDrones()) do
				if (v.Parent == model) then
					v.Transparency = value
				end
			end

			return
		end
	end
	
	local drone = Functions.GetDrone(droneId)
	if (drone == nil) then return end

	drone.Transparency = value
end

function RE.SetColor(droneId, color)
	if (droneId == "all") then
		Functions.SetColor(color)
		
		for k,v in pairs(Functions.GetDrones()) do
			v.Color = color
		end
		
		return
	end
	
	if typeof(droneId) == "string" then
		if (droneId:find("group")) then
			droneId = Functions.GetId(droneId)
			if (droneId == nil) then return end

			for k,v in pairs(Functions.GetDrones()) do
				if (v.Group.Value == droneId) then
					v.Color = color
				end
			end

			return
		elseif (droneId:find("model")) then
			droneId = Functions.GetId(droneId)
			if (droneId == nil) then return end

			for k,v in pairs(Functions.GetModel(droneId)) do
				v.Color = color
			end

			return
		end
	end
	
	local drone = Functions.GetDrone(droneId)
	if (drone == nil) then return end
	
	drone.Color = color
end

function RE.Reset(defaults)
	RE.CancelAll("all")
	RE.CancelAll("joint")
	Functions.SetTransparency(defaults.Transparency)
	Functions.SetColor(defaults.Color)
	
	for i = 0, Functions.GetDronesCount() do
		Functions.DeleteDron(i)
	end
end

return RE