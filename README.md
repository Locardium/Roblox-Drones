
# Roblox Drones

A few years ago, when I was working on events in RBLX, we decided to put together a drone show. It was somewhat last-minute, so based on a video from "usercontent" that featured a drone show, I quickly designed something simple yet effective for the event.

Recently, a friend wanted to create a drone show, so I gave him my old script. However, I decided to recreate and improve the script since the original was quite basic, lacking in functionality, and poorly optimized. This led to the birth of this new project. I created it and gave it to him for his event. After the event, I told him I would publish it so that it could be accessible to anyone who wants to use and contribute to this community, which I still hold dear despite no longer being active in it.

There isn’t much to explain about the script itself. It simply creates drones that can perform shows for all connected clients. The drones are generated on each client, and their functions are handled locally. However, the drones are controlled from the server using the API to ensure that all clients see the same show. This setup ensures that the server does not have to expend resources on movements or maintaining additional active actors, among other things.
## Demo

[![Video](https://i.imgur.com/xRomBV5.png)](https://i.gyazo.com/87202cb3aab8ef1bc43825eaa54440e4.mp4)
## Bugs

I found two bugs
- A drone is missing to be generated sometime
- When you use "joint" it may not return to the initial position or rotate from a pivot that is not the exact center.
## Installation

- Download [Release](https://github.com/Locardium/Roblox-Drones/releases/tag/2.0) section and add this item to your game.
- Put the folder in "workspace" and configure the "Settings" file.
- Done.

> You can use the `Drones-Controller` or delete this and create your custom console.
    
## Documentation

### Settings
In Settings file.
- **Whitelist** _(array)_: Add members so they can use `Drones-Controller` (only works with `Drones-Controller`)

- **Speed** _(number)_: This is a default speed for drones.

> The spawn actor (in folder `Drone`), the larger it is, the more random the output of the drones is.

### How create figures

#### With one group
- Create new folder in folder `figures` and put a custom name.

![Screenshot](https://i.imgur.com/Osixfro.png)

- Open folder `drone` and copy `Drone-Template` to new folder.

![Screenshot 2](https://i.imgur.com/QTkMQrC.png)

- Copy `Drone-Template` as many times as necessary to create your figure.

> _(optional)_ you can edit the `Group` value (number) in the `Drone-Template`.

#### With various groups
- Create new folder in folder `figures` and put a custom name.

![Screenshot](https://i.imgur.com/Osixfro.png)

- Create a new folder within the previous one created and make the name just numbers (1 - 999..), so that they are identifiable

![Screenshot 3](https://i.imgur.com/jYhcimS.png)

- Open folder `drone` and copy `Drone-Template` to new folder.

![Screenshot 4](https://i.imgur.com/JNNLgTq.png)

- Copy `Drone-Template` as many times as necessary to create your figure.

- Repeat step number 2 until you obtain the desired number of groups.

> _(optional)_ you can edit the `Group` value (number) in the `Drone-Template`.

## API Reference

### How to call API
```lua
local API = require(game.ServerStorage:WaitForChild("Drones-SS").API)
```

### API Functions
#### GetFiguresName()

- **Description**: Retrieves the names of all figures available.
- **Parameters**: None
- **Returns**: A table containing the names of figures.

```lua
  local figures = API.GetFiguresName()
  print(figures) --returns {[1] = "figure1", [2] = "figure2", ...}
```

#### GetCurrentFigureName()

- **Description**: Retrieves the name of the currently selected figure.
- **Parameters**: None
- **Returns**: A string representing the name of the current figure.

```lua
  local figure = API.GetCurrentFigureName()
  print(figure) --returns "figure1" or nil
```

#### GetTotalDrones()

- **Description**: Retrieves the total number of drones associated with the current figure.
- **Parameters**: None
- **Returns**: An integer representing the total number of drones.

```lua
  local drones = API.GetTotalDrones()
  print(drones) --returns 0
```

#### ChangeFigure(figureName)

- **Description**: Changes the current figure to the one specified.
- **Parameters**:
  - `figureName` _(string)_: The name of the figure to change to.
- **Returns**: None

```lua
  API.ChangeFigure("figure1")
```

#### MoveDrones(modelId, x, y, z, speed, isGlobal)

- **Description**: Initiates movement for drones.
- **Parameters**:
  - `modelId` _(string or number)_: `ModelId` or `"all"` or `"joint"`.
  - `x, y, z` _(number)_: Movement distances in each axis.
  - `speed` _(number) (optional)_: Movement speed.
  - `isGlobal` _(boolean) (optional)_: Whether the movement is global or local. Default `false`
- **Returns**: None

```lua
  --Example 1
  API.MoveDrones(1, 0, 0, 10)
  --Example 2
  API.MoveDrones("all", 0, 0, 10, 4)
  --Example 3
  API.MoveDrones("joint", 0, 0, 10, nil, true)
```

#### RotateDrones(modelId, x, y, z, speed)

- **Description**: Initiates rotation for drones.
- **Parameters**:
  - `modelId` _(string or number)_: `ModelId` or `"all"` or `"joint"`.
  - `x, y, z` _(number)_: Rotation angles in each axis.
  - `speed` _(number) (optional)_: Rotation speed.
- **Returns**: None

```lua
  --Example 1
  API.RotateDrones(1, 0, 0, 10)
  --Example 2
  API.RotateDrones("all", 0, 0, 10, 4)
  --Example 3
  API.RotateDrones("joint", 0, -5, 0, 3)
```

#### OrbitDrones(modelId, xSpeed, ySpeed, zSpeed)

- **Description**: Initiates orbiting movement for drones, similar to `RotateDrones` but is infinite
- **Parameters**:
  - `modelId` _(string or number)_: `ModelId` or `"all"` or `"joint"`.
  - `xSpeed, ySpeed, zSpeed` _(number)_: Orbital speeds in each axis.
- **Returns**: None

```lua
  --Example 1
  API.OrbitDrones(1, 0, 0, 10)
  --Example 2
  API.OrbitDrones("all", 0, 0, 10)
  --Example 3
  API.OrbitDrones("joint", 0, -5, 0)
```

#### CancelMove(modelId)

- **Description**: Cancels ongoing movement for drones.
- **Parameters**:
  - `modelId` _(string or number)_: `ModelId` or `"all"` or `"joint"`.
- **Returns**: None

```lua
  --Example 1
  API.CancelMove(1)
  --Example 2
  API.CancelMove("all")
  --Example 3
  API.CancelMove("joint")
```

#### CancelRotate(modelId)

- **Description**: Cancels ongoing rotation for drones.
- **Parameters**:
  - `modelId` _(string or number)_: `ModelId` or `"all"` or `"joint"`.
- **Returns**: None

```lua
  --Example 1
  API.CancelRotate(1)
  --Example 2
  API.CancelRotate("all")
  --Example 3
  API.CancelRotate("joint")
```

#### CancelOrbit(modelId)

- **Description**: Cancels ongoing orbiting movement for drones.
- **Parameters**:
  - `modelId` _(string or number)_: `ModelId` or `"all"` or `"joint"`.
- **Returns**: None

```lua
  --Example 1
  API.CancelOrbit(1)
  --Example 2
  API.CancelOrbit("all")
  --Example 3
  API.CancelOrbit("joint")
```

#### SetColor(dronId, color)

- **Description**: Sets the color of drones.
- **Parameters**:
  - `dronId` _(string or number)_: `DronId` or `"all"` or `"group-GroupId"` or `"model-ModelId"`.
  - `color` _(Color3)_: The color to set.
- **Returns**: None

```lua
  --Example 1
  API.SetColor(1, Color3.fromRGB(0, 255, 0))
  --Example 2
  API.SetColor("all", Color3.fromRGB(255, 0, 255))
  --Example 3
  API.SetColor("group-1", Color3.fromRGB(0, 0, 255))
  --or
  API.SetColor("group 1", Color3.fromRGB(0, 0, 255))
  --Example 4
  API.SetColor("model-1", Color3.fromRGB(255, 0, 0))
  --or
  API.SetColor("model 1", Color3.fromRGB(255, 0, 0))
```

#### SetTransparency(dronId, transparency)

- **Description**: Sets the color of drones.
- **Parameters**:
  - `dronId` _(string or number)_: `DronId` or `"all"` or `"group-GroupId"` or `"model-ModelId"`.
  - `transparency` _(number)_: The transparency value to set, which must be between 0 (fully opaque) and 1 (fully transparent).
- **Returns**: None

```lua
  --Example 1
  API.SetTransparency(1, 0)
  --Example 2
  API.SetTransparency("all", 0.6)
  --Example 3
  API.SetTransparency("group-1", 1)
  --or
  API.SetTransparency("group 1", 1)
  --Example 4
  API.SetTransparency("model-1", 0.2)
  --or
  API.SetTransparency("model 1", 0.2)
```

#### API.Reset() 

- **Description**: Resets drones and various parameters to their default values.
- **Parameters**: None
- **Returns**: None

```lua
  API.Reset()
```

