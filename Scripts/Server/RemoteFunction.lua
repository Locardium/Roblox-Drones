local RF = {}

local wsFolder = workspace:WaitForChild("Drones-WS")

local Globals = require(script.Parent.Globals)
local Settings = require(wsFolder.Settings)

function RF.GetServerData()
	return {
		Figures = Globals.Figures,
		Figure = Globals.Figure,
		Transparency = Globals.Transparency,
		Color = Globals.Color,
		Speed = Settings.Speed
	}
end

return RF