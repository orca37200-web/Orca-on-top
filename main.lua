-- GUI Trade Scam - Orcahub Edition
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICornerMain = Instance.new("UICorner")
local Title = Instance.new("TextLabel")

-- Fungsi slider toggle otomatis
local function createSliderToggle(name, position)
    local Frame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local Label = Instance.new("TextLabel")
    local ToggleBG = Instance.new("TextButton")
    local UICornerBG = Instance.new("UICorner")
    local ToggleDot = Instance.new("Frame")
    local UICornerDot = Instance.new("UICorner")

    Frame.Name = name.."Frame"
    Frame.Parent = MainFrame
    Frame.Size = UDim2.new(0, 180, 0, 40)
    Frame.Position = position
    Frame.BackgroundColor3 = Color3.new(0, 0, 0)

    UICorner.CornerRadius = UDim.new(0, 16)
    UICorner.Parent = Frame

    Label.Name = name.."Label"
    Label.Parent = Frame
    Label.Text = name
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Position = UDim2.new(0.05, 0, 0, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.TextScaled = true
    Label.Font = Enum.Font.SourceSansBold

    ToggleBG.Name = "ToggleBG"
    ToggleBG.Parent = Frame
    ToggleBG.Size = UDim2.new(0, 45, 0, 20)
    ToggleBG.Position = UDim2.new(0.7, 0, 0.5, -10)
    ToggleBG.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    ToggleBG.AutoButtonColor = false
    ToggleBG.Text = ""

    UICornerBG.CornerRadius = UDim.new(0, 10)
    UICornerBG.Parent = ToggleBG

    ToggleDot.Name = "ToggleDot"
    ToggleDot.Parent = ToggleBG
    ToggleDot.Size = UDim2.new(0, 16, 0, 16)
    ToggleDot.Position = UDim2.new(0, 2, 0, 2)
    ToggleDot.BackgroundColor3 = Color3.new(1, 1, 1)

    UICornerDot.CornerRadius = UDim.new(0, 6)
    UICornerDot.Parent = ToggleDot

    -- Toggle logic
    local isOn = false
    ToggleBG.MouseButton1Click:Connect(function()
        isOn = not isOn
        if isOn then
            ToggleDot:TweenPosition(UDim2.new(0.55, 0, 0, 2), "Out", "Sine", 0.2, true)
            ToggleBG.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        else
            ToggleDot:TweenPosition(UDim2.new(0, 2, 0, 2), "Out", "Sine", 0.2, true)
            ToggleBG.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        end
    end)
end

-- GUI Setup
ScreenGui.Name = "TradeScamGUI"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 210, 0, 190)
MainFrame.Position = UDim2.new(0.5, -105, 0.5, -95)
MainFrame.BackgroundColor3 = Color3.new(1, 1, 1)
MainFrame.BorderSizePixel = 4
MainFrame.BorderColor3 = Color3.new(0, 0, 0)
MainFrame.Active = true
MainFrame.Draggable = true

UICornerMain.CornerRadius = UDim.new(0, 16)
UICornerMain.Parent = MainFrame

Title.Name = "Title"
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0.2, 0)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Orcahub" -- تم التعديل إلى الاسم الجديد
Title.TextColor3 = Color3.new(0, 0, 0)
Title.Font = Enum.Font.SourceSansBold
Title.TextScaled = true

-- الأزرار
createSliderToggle("Freeze Trade", UDim2.new(0, 15, 0, 50))
createSliderToggle("Auto Accept", UDim2.new(0, 15, 0, 95))
createSliderToggle("Auto Add Fruit", UDim2.new(0, 15, 0, 140))
