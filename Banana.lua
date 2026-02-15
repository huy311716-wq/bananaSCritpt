-- Chờ game và player sẵn sàng
if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Xóa UI cũ nếu có để tránh trùng lặp
local oldGui = PlayerGui:FindFirstChild("FPS_PING_SYSTEM_FIXED")
if oldGui then oldGui:Destroy() end

local Gui = Instance.new("ScreenGui")
Gui.Name = "FPS_PING_SYSTEM_FIXED"
Gui.ResetOnSpawn = false
Gui.Parent = PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 240, 0, 80)
Frame.Position = UDim2.new(0.5, -120, 0.1, 0)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Frame.BackgroundTransparency = 0.2
Frame.BorderSizePixel = 0
Frame.Visible = false -- Sẽ hiện sau khi Notify xong
Frame.Parent = Gui

local Corner = Instance.new("UICorner", Frame)
Corner.CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke", Frame)
Stroke.Thickness = 2

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "AOV • FPS & PING"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Parent = Frame

local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1, 0, 0, 40)
Info.Position = UDim2.new(0, 0, 0, 35)
Info.BackgroundTransparency = 1
Info.Text = "FPS: -- | Ping: --"
Info.Font = Enum.Font.Gotham
Info.TextSize = 14
Info.TextColor3 = Color3.new(1, 1, 1)
Info.Parent = Frame

-- Vòng lặp tối ưu: Rainbow & FPS
local fps = 0
RunService.RenderStepped:Connect(function(dt)
    fps = math.floor(1 / dt)
    local rainbow = Color3.fromHSV((os.clock() % 5) / 5, 0.8, 1)
    Title.TextColor3 = rainbow
    Stroke.Color = rainbow
end)

task.spawn(function()
    while task.wait(0.5) do
        local ping = math.floor(Player:GetNetworkPing() * 1000)
        Info.Text = string.format("FPS: %d | Ping: %d ms", fps, ping)
    end
end)

-- Hệ thống kéo thả mượt
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

-- Notify Startup (CHỖ FIX CHÍNH)
local function Startup()
    local N = Instance.new("Frame")
    N.Size = UDim2.new(0, 260, 0, 60)
    N.Position = UDim2.new(1, 20, 0, 50)
    N.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    N.Parent = Gui
    Instance.new("UICorner", N).CornerRadius = UDim.new(0, 8)
    
    local NT = Instance.new("TextLabel")
    NT.Size = UDim2.new(1, 0, 1, 0)
    NT.BackgroundTransparency = 1
    NT.Text = "Vận hành hệ thống AOV..."
    NT.Font = Enum.Font.GothamMedium
    NT.TextColor3 = Color3.new(1, 1, 1)
    NT.TextSize = 13
    NT.Parent = N

    -- Dùng EasingStyle và EasingDirection tách biệt để không bao giờ lỗi
    local tweenIn = TweenService:Create(N, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -280, 0, 50)})
    local tweenOut = TweenService:Create(N, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 20, 0, 50)})

    tweenIn:Play()
    
    task.delay(2.5, function()
        tweenOut:Play()
        task.wait(0.5)
        N:Destroy()
        Frame.Visible = true
        
        -- Gọi script phụ
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/main/BananaCat-kaitunBF.lua"))()
        end)
    end)
end

Startup()
