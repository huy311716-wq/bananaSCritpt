-- Chờ game tải
if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Tạo UI
local Gui = Instance.new("ScreenGui")
Gui.Name = "AOV_SYSTEM_FIXED"
Gui.ResetOnSpawn = false
Gui.Parent = PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 240, 0, 80)
Frame.Position = UDim2.new(0.5, -120, 0.1, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BackgroundTransparency = 0.2
Frame.BorderSizePixel = 0
Frame.Visible = false
Frame.Parent = Gui

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)
local Stroke = Instance.new("UIStroke", Frame)
Stroke.Thickness = 2

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "FPS • PING"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 16
Title.Parent = Frame

local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1, 0, 0, 40)
Info.Position = UDim2.new(0, 0, 0, 35)
Info.BackgroundTransparency = 1
Info.Font = Enum.Font.Gotham
Info.TextColor3 = Color3.new(1, 1, 1)
Info.TextSize = 14
Info.Parent = Frame

-- Vòng lặp cập nhật FPS/Rainbow
local fps = 0
RunService.RenderStepped:Connect(function(dt)
    fps = math.floor(1 / dt)
    local c = Color3.fromHSV((os.clock() % 5) / 5, 0.75, 1)
    Title.TextColor3 = c
    Stroke.Color = c
end)

task.spawn(function()
    while task.wait(0.5) do
        local ping = math.floor(Player:GetNetworkPing() * 1000)
        Info.Text = string.format("FPS: %d | Ping: %d ms", fps, ping)
    end
end)

-- Kéo thả UI
local dragging, dragStart, startPos
Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Thông báo khởi động (Chỗ bị lỗi lúc trước)
local function Startup()
    local N = Instance.new("Frame")
    N.Size = UDim2.new(0, 280, 0, 70)
    N.Position = UDim2.new(1, 20, 0, 50)
    N.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    N.Parent = Gui
    Instance.new("UICorner", N).CornerRadius = UDim.new(0, 10)

    local T = Instance.new("TextLabel")
    T.Size = UDim2.new(1, 0, 1, 0)
    T.BackgroundTransparency = 1
    T.Text = "Đang kết nối hệ thống..."
    T.TextColor3 = Color3.new(1, 1, 1)
    T.Font = Enum.Font.GothamMedium
    T.TextSize = 14
    T.Parent = N

    -- FIX Ở ĐÂY: Dùng Enum.EasingStyle.Quad và Enum.EasingDirection.Out/In riêng biệt
    local infoIn = TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local infoOut = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

    TweenService:Create(N, infoIn, {Position = UDim2.new(1, -300, 0, 50)}):Play()

    task.delay(2.5, function()
        TweenService:Create(N, infoOut, {Position = UDim2.new(1, 20, 0, 50)}):Play()
        task.wait(0.5)
        N:Destroy()
        Frame.Visible = true
        
        -- Load script phụ
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/main/BananaCat-kaitunBF.lua"))()
        end)
    end)
end

Startup()
