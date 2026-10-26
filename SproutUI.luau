--!strict
-- SproutUI: small, dependency-free client UI helpers for Roblox.
local SproutUI = {}

export type WindowOptions = { title: string?, width: number?, height: number? }

local function corner(parent: Instance)
 local item = Instance.new("UICorner")
 item.CornerRadius = UDim.new(0, 10)
 item.Parent = parent
end

function SproutUI.window(playerGui: PlayerGui, options: WindowOptions?)
 local config = options or {}
 local screen = Instance.new("ScreenGui")
 screen.Name = "SproutUI"
 screen.ResetOnSpawn = false
 screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
 local frame = Instance.new("Frame")
 frame.Size = UDim2.fromOffset(config.width or 360, config.height or 300)
 frame.AnchorPoint = Vector2.new(0.5, 0.5)
 frame.Position = UDim2.fromScale(0.5, 0.5)
 frame.BackgroundColor3 = Color3.fromRGB(25, 29, 38)
 frame.Parent = screen
 corner(frame)
 local constraint = Instance.new("UISizeConstraint")
 constraint.MaxSize = Vector2.new(config.width or 360, config.height or 300)
 constraint.Parent = frame
 -- Scale down on small viewports without discarding the requested desktop size.
 local scale = Instance.new("UIScale")
 scale.Parent = frame
 local cameraConnection: RBXScriptConnection? = nil
 local viewportConnection: RBXScriptConnection? = nil
 local function resize()
  local camera = workspace.CurrentCamera
  if camera then
   scale.Scale = math.min(1, math.max(0.1, (camera.ViewportSize.X - 24) / (config.width or 360)), math.max(0.1, (camera.ViewportSize.Y - 24) / (config.height or 300)))
  end
 end
 local function bindCamera()
  if viewportConnection then viewportConnection:Disconnect() end
  local camera = workspace.CurrentCamera
  if camera then viewportConnection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(resize) end
  resize()
 end
 cameraConnection = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindCamera)
 bindCamera()
 local padding = Instance.new("UIPadding")
 padding.PaddingTop = UDim.new(0, 16)
 padding.PaddingBottom = UDim.new(0, 16)
 padding.PaddingLeft = UDim.new(0, 16)
 padding.PaddingRight = UDim.new(0, 16)
 padding.Parent = frame
 local title = Instance.new("TextLabel")
 title.Size = UDim2.new(1, 0, 0, 32)
 title.BackgroundTransparency = 1
 title.Text = config.title or "SproutUI"
 title.TextColor3 = Color3.fromRGB(240, 244, 250)
 title.Font = Enum.Font.GothamBold
 title.TextSize = 20
 title.TextXAlignment = Enum.TextXAlignment.Left
 title.Parent = frame
 local content = Instance.new("ScrollingFrame")
 content.Position = UDim2.fromOffset(0, 44)
 content.Size = UDim2.new(1, 0, 1, -44)
 content.BackgroundTransparency = 1
 content.BorderSizePixel = 0
 content.ScrollBarThickness = 4
 content.CanvasSize = UDim2.fromOffset(0, 0)
 content.AutomaticCanvasSize = Enum.AutomaticSize.Y
 content.Parent = frame
 local layout = Instance.new("UIListLayout")
 layout.Padding = UDim.new(0, 10)
 layout.SortOrder = Enum.SortOrder.LayoutOrder
 layout.Parent = content
 local connections: {RBXScriptConnection} = {}
 local destroyed = false
 local count = 0
 local function checkAlive()
  assert(not destroyed, "SproutUI window has been destroyed")
 end
 local function makeButton(text: string): TextButton
  checkAlive()
  count += 1
  local button = Instance.new("TextButton")
  button.Size = UDim2.new(1, -8, 0, 44)
  button.LayoutOrder = count
  button.BackgroundColor3 = Color3.fromRGB(53, 112, 87)
  button.TextColor3 = Color3.fromRGB(255, 255, 255)
  button.Font = Enum.Font.GothamMedium
  button.TextSize = 16
  button.TextWrapped = true
  button.Text = text
  button.Parent = content
  corner(button)
  return button
 end
 local api = {}
 function api:button(text: string, callback: () -> ())
  local button = makeButton(text)
  table.insert(connections, button.Activated:Connect(callback))
  return button
 end
 function api:toggle(text: string, initial: boolean, callback: (boolean) -> ())
  local state = initial
  local button = makeButton("")
  local function render() button.Text = text .. ": " .. (if state then "ON" else "OFF") end
  render()
  table.insert(connections, button.Activated:Connect(function()
   state = not state
   render()
   callback(state)
  end))
  return button
 end
 local function cleanup()
  if destroyed then return end
  destroyed = true
  for _, connection in connections do connection:Disconnect() end
  if cameraConnection then cameraConnection:Disconnect() end
  if viewportConnection then viewportConnection:Disconnect() end
 end
 screen.Destroying:Connect(cleanup)
 function api:destroy()
  cleanup()
  screen:Destroy()
 end
 screen.Parent = playerGui
 return api
end

return SproutUI
