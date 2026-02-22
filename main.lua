--[[
╔═══════════════════════════════════════════════════════════════╗
║                 🐋 ORCA TIME TRACKER v1.0                      ║
║                                                               ║
║            Creator: ORCA | Version: 1.0 | Status: ⏱️           ║
║                                                               ║
║        - يحسب وقتك في السيرفر                                   ║
║        - يحسب وقت أي لاعب (حط اسمه)                            ║
║        - النقاط الحمراء للوقت الزائد                           ║
║                                                               ║
║                   Press [F9] to Open Menu                     ║
╚═══════════════════════════════════════════════════════════════╝
--]]

repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
wait(1)

-- ==================== الخدمات ====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- ==================== اللاعب المحلي ====================
local LocalPlayer = Players.LocalPlayer

-- ==================== إعدادات الوقت والنقاط ====================
local TimeTracker = {
    StartTime = os.clock(),
    TotalTime = 0,
    Points = 0,
    RedPoints = 0,
    LastUpdate = os.clock(),
    PlayersData = {},
    TargetPlayer = nil,
    TargetTime = 0,
    TargetPoints = 0
}

-- ==================== دوال حساب الوقت ====================

-- تحديث وقت اللاعب المحلي
local function UpdateLocalTime()
    local currentTime = os.clock()
    local elapsed = currentTime - TimeTracker.LastUpdate
    TimeTracker.TotalTime = TimeTracker.TotalTime + elapsed
    
    -- حساب النقاط (كل 5 دقائق = 300 ثانية = 1 نقطة)
    local newPoints = math.floor(TimeTracker.TotalTime / 300)
    if newPoints > TimeTracker.Points then
        TimeTracker.Points = newPoints
        -- كل 5 نقاط تتحول لنقطة حمراء
        TimeTracker.RedPoints = math.floor(TimeTracker.Points / 5)
        
        -- إشعار عند كل نقطة جديدة
        StarterGui:SetCore("SendNotification", {
            Title = "⏱️ ORCA Timer",
            Text = "حصلت على نقطة! (الوقت: " .. math.floor(TimeTracker.TotalTime / 60) .. " دقيقة)",
            Duration = 2
        })
    end
    
    TimeTracker.LastUpdate = currentTime
end

-- حساب وقت لاعب معين
local function CalculatePlayerTime(player)
    if not player then return 0, 0 end
    
    local joinTime = TimeTracker.PlayersData[player.Name]
    if not joinTime then return 0, 0 end
    
    local currentTime = os.clock()
    local totalTime = currentTime - joinTime
    local points = math.floor(totalTime / 300)
    local redPoints = math.floor(points / 5)
    
    return totalTime, points, redPoints
end

-- تتبع دخول اللاعبين
Players.PlayerAdded:Connect(function(player)
    TimeTracker.PlayersData[player.Name] = os.clock()
    print("📥 لاعب دخل: " .. player.Name .. " الساعة " .. os.date("%H:%M:%S"))
end)

Players.PlayerRemoving:Connect(function(player)
    local time, points, red = CalculatePlayerTime(player)
    print("📤 لاعب خرج: " .. player.Name)
    print("   الوقت: " .. math.floor(time / 60) .. " دقيقة")
    print("   النقاط: " .. points .. " (أحمر: " .. red .. ")")
    TimeTracker.PlayersData[player.Name] = nil
end)

-- ==================== واجهة المستخدم ====================
local function CreateUI()
    -- حذف القديم
    local old = CoreGui:FindFirstChild("ORCATimeTracker")
    if old then old:Destroy() end
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "ORCATimeTracker"
    gui.Parent = CoreGui
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- الإطار الرئيسي (مصغر)
    local main = Instance.new("Frame")
    main.Name = "MainFrame"
    main.Size = UDim2.new(0, 350, 0, 450)
    main.Position = UDim2.new(0.5, -175, 0.5, -225)
    main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    main.BackgroundTransparency = 0.1
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    main.Visible = true
    main.Parent = gui
    
    -- زوايا دائرية
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = main
    
    -- العنوان
    local title = Instance.new("Frame")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    title.BorderSizePixel = 0
    title.Parent = main
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = title
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -30, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "🐋 ORCA Time Tracker"
    titleText.TextColor3 = Color3.new(1, 1, 1)
    titleText.TextSize = 18
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = title
    
    -- زر الإغلاق
    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 30, 0, 30)
    close.Position = UDim2.new(1, -35, 0, 5)
    close.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    close.Text = "✕"
    close.TextColor3 = Color3.new(1, 1, 1)
    close.TextSize = 16
    close.Font = Enum.Font.GothamBold
    close.Parent = title
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = close
    
    close.MouseButton1Click:Connect(function()
        main.Visible = false
    end)
    
    -- المحتوى الرئيسي
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -20, 1, -50)
    content.Position = UDim2.new(0, 10, 0, 45)
    content.BackgroundTransparency = 1
    content.Parent = main
    
    local y = 0
    
    -- ===== وقتك الخاص =====
    local yourTimeTitle = Instance.new("TextLabel")
    yourTimeTitle.Size = UDim2.new(1, 0, 0, 25)
    yourTimeTitle.Position = UDim2.new(0, 0, 0, y)
    yourTimeTitle.BackgroundTransparency = 1
    yourTimeTitle.Text = "⏱️ وقتك في السيرفر"
    yourTimeTitle.TextColor3 = Color3.fromRGB(0, 200, 255)
    yourTimeTitle.TextSize = 16
    yourTimeTitle.Font = Enum.Font.GothamBold
    yourTimeTitle.TextXAlignment = Enum.TextXAlignment.Left
    yourTimeTitle.Parent = content
    
    y = y + 30
    
    -- عرض وقتك
    local yourTimeLabel = Instance.new("TextLabel")
    yourTimeLabel.Size = UDim2.new(1, 0, 0, 25)
    yourTimeLabel.Position = UDim2.new(0, 0, 0, y)
    yourTimeLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    yourTimeLabel.Text = "جاري الحساب..."
    yourTimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    yourTimeLabel.TextSize = 14
    yourTimeLabel.Font = Enum.Font.Gotham
    yourTimeLabel.Parent = content
    
    local yourTimeCorner = Instance.new("UICorner")
    yourTimeCorner.CornerRadius = UDim.new(0, 5)
    yourTimeCorner.Parent = yourTimeLabel
    
    y = y + 30
    
    -- نقاطك
    local yourPointsLabel = Instance.new("TextLabel")
    yourPointsLabel.Size = UDim2.new(1, 0, 0, 25)
    yourPointsLabel.Position = UDim2.new(0, 0, 0, y)
    yourPointsLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    yourPointsLabel.Text = "نقاطك: 0 (أحمر: 0)"
    yourPointsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    yourPointsLabel.TextSize = 14
    yourPointsLabel.Font = Enum.Font.Gotham
    yourPointsLabel.Parent = content
    
    local yourPointsCorner = Instance.new("UICorner")
    yourPointsCorner.CornerRadius = UDim.new(0, 5)
    yourPointsCorner.Parent = yourPointsLabel
    
    y = y + 40
    
    -- ===== حساب لاعب آخر =====
    local otherTitle = Instance.new("TextLabel")
    otherTitle.Size = UDim2.new(1, 0, 0, 25)
    otherTitle.Position = UDim2.new(0, 0, 0, y)
    otherTitle.BackgroundTransparency = 1
    otherTitle.Text = "🎯 احسب وقت لاعب آخر"
    otherTitle.TextColor3 = Color3.fromRGB(255, 200, 0)
    otherTitle.TextSize = 16
    otherTitle.Font = Enum.Font.GothamBold
    otherTitle.TextXAlignment = Enum.TextXAlignment.Left
    otherTitle.Parent = content
    
    y = y + 30
    
    -- حقل إدخال اسم اللاعب
    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(1, 0, 0, 35)
    inputBox.Position = UDim2.new(0, 0, 0, y)
    inputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    inputBox.PlaceholderText = "اكتب اسم اللاعب هنا..."
    inputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    inputBox.Text = ""
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.TextSize = 14
    inputBox.Font = Enum.Font.Gotham
    inputBox.ClearTextOnFocus = false
    inputBox.Parent = content
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 5)
    inputCorner.Parent = inputBox
    
    y = y + 40
    
    -- زر البحث
    local searchBtn = Instance.new("TextButton")
    searchBtn.Size = UDim2.new(1, 0, 0, 35)
    searchBtn.Position = UDim2.new(0, 0, 0, y)
    searchBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    searchBtn.Text = "🔍 احسب الوقت"
    searchBtn.TextColor3 = Color3.new(1, 1, 1)
    searchBtn.TextSize = 14
    searchBtn.Font = Enum.Font.GothamBold
    searchBtn.Parent = content
    
    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 5)
    searchCorner.Parent = searchBtn
    
    y = y + 40
    
    -- نتيجة البحث
    local resultFrame = Instance.new("Frame")
    resultFrame.Size = UDim2.new(1, 0, 0, 60)
    resultFrame.Position = UDim2.new(0, 0, 0, y)
    resultFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    resultFrame.BackgroundTransparency = 0.2
    resultFrame.Parent = content
    
    local resultCorner = Instance.new("UICorner")
    resultCorner.CornerRadius = UDim.new(0, 5)
    resultCorner.Parent = resultFrame
    
    local resultText = Instance.new("TextLabel")
    resultText.Size = UDim2.new(1, -10, 0.5, 0)
    resultText.Position = UDim2.new(0, 5, 0, 5)
    resultText.BackgroundTransparency = 1
    resultText.Text = "لم يتم البحث بعد"
    resultText.TextColor3 = Color3.fromRGB(200, 200, 200)
    resultText.TextSize = 14
    resultText.Font = Enum.Font.Gotham
    resultText.TextXAlignment = Enum.TextXAlignment.Left
    resultText.Parent = resultFrame
    
    local resultPoints = Instance.new("TextLabel")
    resultPoints.Size = UDim2.new(1, -10, 0.5, 0)
    resultPoints.Position = UDim2.new(0, 5, 0, 30)
    resultPoints.BackgroundTransparency = 1
    resultPoints.Text = "نقاط: -"
    resultPoints.TextColor3 = Color3.fromRGB(200, 200, 200)
    resultPoints.TextSize = 12
    resultPoints.Font = Enum.Font.Gotham
    resultPoints.TextXAlignment = Enum.TextXAlignment.Left
    resultPoints.Parent = resultFrame
    
    -- وظيفة زر البحث
    searchBtn.MouseButton1Click:Connect(function()
        local playerName = inputBox.Text
        if playerName == "" then
            resultText.Text = "اكتب اسم لاعب أولاً"
            resultPoints.Text = ""
            return
        end
        
        local targetPlayer = Players:FindFirstChild(playerName)
        if not targetPlayer then
            resultText.Text = "❌ لاعب غير موجود"
            resultPoints.Text = ""
            return
        end
        
        local time, points, redPoints = CalculatePlayerTime(targetPlayer)
        
        resultText.Text = "🎯 " .. targetPlayer.Name
        if time > 0 then
            local minutes = math.floor(time / 60)
            local seconds = math.floor(time % 60)
            resultPoints.Text = "⏱️ الوقت: " .. minutes .. " دقيقة " .. seconds .. " ثانية"
            
            -- تحديد لون النص بناء على النقاط الحمراء
            if redPoints > 0 then
                resultPoints.TextColor3 = Color3.fromRGB(255, 0, 0) -- أحمر
                resultPoints.Text = resultPoints.Text .. " | 🔴 نقاط حمراء: " .. redPoints
            else
                resultPoints.TextColor3 = Color3.fromRGB(0, 255, 0) -- أخضر
                resultPoints.Text = resultPoints.Text .. " | نقاط: " .. points
            end
        else
            resultText.Text = targetPlayer.Name .. " (ما لحق يجمع نقاط)"
            resultPoints.Text = "نقاط: 0"
            resultPoints.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end)
    
    y = y + 70
    
    -- تحديث دوري للشاشة
    spawn(function()
        while true do
            wait(1)
            
            -- تحديث وقتك
            UpdateLocalTime()
            
            -- عرض وقتك
            local minutes = math.floor(TimeTracker.TotalTime / 60)
            local seconds = math.floor(TimeTracker.TotalTime % 60)
            local hours = math.floor(minutes / 60)
            minutes = minutes % 60
            
            if hours > 0 then
                yourTimeLabel.Text = string.format("⏱️ %d ساعة %d دقيقة %d ثانية", hours, minutes, seconds)
            else
                yourTimeLabel.Text = string.format("⏱️ %d دقيقة %d ثانية", minutes, seconds)
            end
            
            -- عرض نقاطك
            yourPointsLabel.Text = "نقاطك: " .. TimeTracker.Points .. " | 🔴 نقاط حمراء: " .. TimeTracker.RedPoints
            if TimeTracker.RedPoints > 0 then
                yourPointsLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            else
                yourPointsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        end
    end)
    
    return gui
end

-- ==================== بدء التشغيل ====================
local function Initialize()
    print("🐋 [ORCA Timer] جاري التشغيل...")
    
    -- تسجيل وقت دخولك
    TimeTracker.StartTime = os.clock()
    TimeTracker.LastUpdate = os.clock()
    TimeTracker.PlayersData[LocalPlayer.Name] = os.clock()
    
    -- تسجيل كل اللاعبين الموجودين
    for _, player in pairs(Players:GetPlayers()) do
        TimeTracker.PlayersData[player.Name] = os.clock()
    end
    
    -- إنشاء الواجهة
    local ui = CreateUI()
    
    -- ربط F9 لفتح القائمة
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.F9 then
            if ui and ui:FindFirstChild("MainFrame") then
                ui.MainFrame.Visible = not ui.MainFrame.Visible
            end
        end
    end)
    
    -- رسالة بداية
    StarterGui:SetCore("SendNotification", {
        Title = "🐋 ORCA Time Tracker",
        Text = "اشتغل! اضغط F9 لفتح القائمة",
        Duration = 3
    })
    
    print("✅ [ORCA Timer] شغال!")
    print("📌 اضغط F9 لفتح القائمة")
end

-- بدء التشغيل
pcall(Initialize)

-- ==================== النهاية ====================
return "🐋 ORCA Time Tracker - شغال يا معلم!"
