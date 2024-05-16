local lerper = {}
local run = game:GetService("RunService")

local lerpFunctions = {
	InSine = function(T)
		return 1 - math.cos(T * 1.5707963267949)
	end,
	OutSine = function(T)
		return math.sin(T * 1.5707963267949)
	end,
	InOutSine = function(T)
		return (1 - math.cos(3.1415926535898 * T)) / 2
	end,
	OutQuad = function(T)
		return T * (2 - T)
	end,
}
export type LerperParams = {
	LerpTime: number,
	Start: CFrame,
	End: CFrame,
	Accelerate: boolean,
	Decelerate: boolean,
}

export type BezierLerperParams = {
	LerpTime: number,
	Accelerate: boolean,
	Decelerate: boolean,
	PositionCurve: table,
	OrientationCurve: table,
}

export type DataLerperParams = {
	LerpTime: number,
	Setting: string,
	Goal: any,
}

local function Map(n: number, oldMin: number, oldMax: number, min: number, max: number)
	return (min + ((max - min) * ((n - oldMin) / (oldMax - oldMin))))
end

function lerper.newCframe(params: LerperParams)

	local x, y, z = params.Start:ToEulerAnglesXYZ()
	local lerp = {
		startTime = tick(),
		endTime = tick() + params.LerpTime,
		value = {
			CFrame = params.Start,
			Position = params.Start.Position,
			Orientation = Vector3.new(x, y, z),
		},
		ended = false,
	}

	lerp.connection = run.RenderStepped:Connect(function()
		if tick() > lerp.endTime then
			lerp.connection:Disconnect()
			lerp.ended = true
		end
		local timeProgress = Map(tick(), lerp.startTime, lerp.endTime, 0, 1)
		local progress = timeProgress
		if params.Accelerate and params.Decelerate then
			progress = lerpFunctions.InOutSine(timeProgress)
		elseif params.Accelerate then
			progress = lerpFunctions.InSine(timeProgress)
		elseif params.Decelerate then
			progress = lerpFunctions.OutSine(timeProgress)
		end
		local cf = params.Start:Lerp(params.End, progress)
		local x, y, z = cf:ToEulerAnglesXYZ()
		lerp.value = {
			CFrame = cf,
			Position = cf.Position,
			Orientation = Vector3.new(x, y, z),
		}
	end)

	return lerp
end

function lerper.newCframeBezier(params: BezierLerperParams)
	local lerp = {
		startTime = tick(),
		endTime = tick() + params.LerpTime,
		value = {
			Position = params.Start.Position,
			Orientation = params.Start:ToOrientation(),
		},
		ended = false,
	}

	lerp.connection = run.RenderStepped:Connect(function()
		if tick() > lerp.endTime then
			lerp.connection:Disconnect()
			lerp.ended = true
		end
		local timeProgress = Map(tick(), lerp.startTime, lerp.endTime, 0, 1)
		local progress = timeProgress
		if params.Accelerate and params.Decelerate then
			progress = lerpFunctions.InOutSine(timeProgress)
		elseif params.Accelerate then
			progress = lerpFunctions.InSine(timeProgress)
		elseif params.Decelerate then
			progress = lerpFunctions.OutSine(timeProgress)
		end
		local pos = params.PositionCurve:Get(progress)
		local ori = params.OrientationCurve:Get(progress)
		lerp.value.Position = pos
		lerp.value.Orientation = ori
	end)

	return lerp
end

function lerper.newInt2(params: LerperParams)
	local lerp = {
		startTime = tick(),
		endTime = tick() + params.LerpTime,
		value = params.Start,
		ended = false,
	}

	lerp.connection = run.RenderStepped:Connect(function()
		if tick() > lerp.endTime then
			lerp.connection:Disconnect()
			lerp.ended = true
		end
		
		local timeProgress = Map(tick(), lerp.startTime, lerp.endTime, 0, 1)
		local progress = timeProgress
		if params.Accelerate and params.Decelerate then
			progress = lerpFunctions.InOutSine(timeProgress)
		elseif params.Accelerate then
			progress = lerpFunctions.InSine(timeProgress)
		elseif params.Decelerate then
			progress = lerpFunctions.OutSine(timeProgress)
		end
		
		local cf = params.Start:Lerp(params.End, progress)
		lerp.value = cf
	end)

	return lerp
end

function lerper.newInt(params: LerperParams)
	local lerp = {
		startTime = tick(),
		endTime = tick() + params.LerpTime,
		value = params.Start,
		ended = false,
	}
	
	lerp.connection = run.RenderStepped:Connect(function()
		if tick() > lerp.endTime then
			lerp.connection:Disconnect()
			lerp.ended = true
		end
		
		local timeProgress = Map(tick(), lerp.startTime, lerp.endTime, 0, 1)
		local progress = lerpFunctions.OutQuad(timeProgress)
		
		lerp.value = Map(progress, 0, 1, params.Start, params.End)
	end)
	
	return lerp
end

function lerper.newIntC(params: LerperParams)
	local lerp = {
		startTime = tick(),
		endTime = tick() + params.LerpTime,
		ended = false,
	}
	
	local start = params.Source[params.Goal]

	lerp.connection = run.RenderStepped:Connect(function()
		if tick() > lerp.endTime then
			lerp.connection:Disconnect()
			lerp.ended = true
		end

		local timeProgress = Map(tick(), lerp.startTime, lerp.endTime, 0, 1)
		local progress = lerpFunctions.OutQuad(timeProgress)

		params.Source[params.Goal] = Map(progress, 0, 1, start, params.End)
	end)

	return lerp
end

return lerper