local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- // CONFIGURATION //
local UI_CONFIG = {
    MainColor = Color3.fromRGB(15, 25, 20),        -- Dark green BG
    StrokeColor = Color3.fromRGB(60, 200, 120),   -- Neon green outline
    TextColor = Color3.fromRGB(120, 255, 180),    -- Green title
    SubTextColor = Color3.fromRGB(170, 200, 185),
    AccentColor = Color3.fromRGB(80, 220, 140),
    ToggleOn = Color3.fromRGB(90, 255, 160),
    ToggleOff = Color3.fromRGB(50, 70, 60),
    Font = Enum.Font.GothamBold,
    CornerRadius = UDim.new(0, 12)
}

-- // INSTANCE CREATION HELPER //
local function Create(className, properties, children)
    local instance = Instance.new(className)
    for k, v in pairs(properties or {}) do
        instance[k] = v
    end
    for _, child in pairs(children or {}) do
        child.Parent = instance
    end
    return instance
end

-- // UI CONSTRUCTION //
if CoreGui:FindFirstChild("222_Lagger") then
    CoreGui["222_Lagger"]:Destroy()
end

local ScreenGui = Create("ScreenGui", {
    Name = "222_Lagger",
    Parent = CoreGui,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})

local MainFrame = Create("Frame", {
    Name = "MainFrame",
    BackgroundColor3 = UI_CONFIG.MainColor,
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, -150, 0.5, -225),
    Size = UDim2.new(0, 320, 0, 520),
    Parent = ScreenGui
}, {
    Create("UICorner", {CornerRadius = UI_CONFIG.CornerRadius}),
    Create("UIStroke", {
        Color = UI_CONFIG.StrokeColor,
        Thickness = 2,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
})

-- // HEADER //
local Header = Create("Frame", {
    Name = "Header",
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 60),
    Parent = MainFrame
}, {
    Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 10),
        Size = UDim2.new(0, 200, 0, 25),
        Font = Enum.Font.GothamBlack,
        Text = "222 Lagger",
        TextColor3 = UI_CONFIG.TextColor,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left
    }),
    Create("TextLabel", {
        Name = "SubTitle",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 30),
        Size = UDim2.new(0, 200, 0, 15),
        Font = Enum.Font.Gotham,
        Text = "made by Sub2BK | discord.gg/bkshub",
        TextColor3 = UI_CONFIG.SubTextColor,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left
    }),
    Create("TextButton", {
        Name = "CloseBtn",
        BackgroundColor3 = Color3.fromRGB(160, 60, 60),
        Position = UDim2.new(1, -35, 0, 10),
        Size = UDim2.new(0, 25, 0, 25),
        Font = Enum.Font.GothamBold,
        Text = "x",
        TextColor3 = Color3.new(1,1,1),
        TextSize = 14,
        AutoButtonColor = false
    }, {
        Create("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
})

Header.CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- // DRAG //
local dragging, dragInput, dragStart, startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- // CONTENT //
local Content = Create("Frame", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 10, 0, 60),
    Size = UDim2.new(1, -20, 1, -90),
    Parent = MainFrame
}, {
    Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
})

local function CreateSectionFrame(height)
    return Create("Frame", {
        BackgroundColor3 = Color3.fromRGB(20, 30, 25),
        Size = UDim2.new(1, 0, 0, height or 50),
        BackgroundTransparency = 0.4
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        Create("UIStroke", {
            Color = UI_CONFIG.StrokeColor,
            Thickness = 1,
            Transparency = 0.5
        })
    })
end

-- POWER SLIDER
local PowerSection = CreateSectionFrame(60)
PowerSection.Parent = Content

local PowerLabel = Create("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 10, 0, 5),
    Size = UDim2.new(1, -20, 0, 20),
    Font = UI_CONFIG.Font,
    Text = "Power: 20% (2000 pkts)",
    TextColor3 = Color3.fromRGB(180, 255, 210),
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = PowerSection
})

local PktsLabel = Create("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 10, 0, 5),
    Size = UDim2.new(1, -20, 0, 20),
    Font = UI_CONFIG.Font,
    Text = "0/s",
    TextColor3 = Color3.fromRGB(120, 220, 160),
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Right,
    Parent = PowerSection
})

local SliderBg = Create("Frame", {
    BackgroundColor3 = Color3.fromRGB(10, 15, 12),
    Position = UDim2.new(0, 10, 0, 30),
    Size = UDim2.new(1, -20, 0, 15),
    Parent = PowerSection
}, {
    Create("UICorner", {CornerRadius = UDim.new(1, 0)})
})

local SliderFill = Create("Frame", {
    BackgroundColor3 = UI_CONFIG.AccentColor,
    Size = UDim2.new(0.2, 0, 1, 0),
    Parent = SliderBg
}, {
    Create("UICorner", {CornerRadius = UDim.new(1, 0)})
})

local SliderKnob = Create("Frame", {
    BackgroundColor3 = UI_CONFIG.MainColor,
    Position = UDim2.new(1, -8, 0.5, -8),
    Size = UDim2.new(0, 16, 0, 16),
    Parent = SliderFill
}, {
    Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
    Create("UIStroke", {Color = UI_CONFIG.AccentColor, Thickness = 1})
})

local draggingSlider = false
local sliderValue = 0.2

local function UpdateSlider(input)
    local relativeX = (input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X
    local value = math.clamp(relativeX, 0, 1)
    sliderValue = value
    SliderFill.Size = UDim2.new(value, 0, 1, 0)

    local percent = math.floor(value * 100)
    local packets = math.floor(value * 10000)
    PowerLabel.Text = string.format("Power: %d%% (%d pkts)", percent, packets)
end

SliderBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSlider = true
        UpdateSlider(input)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
        UpdateSlider(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSlider = false
    end
end)

-- BUTTONS
local function CreateButton(text, color)
    local frame = CreateSectionFrame(45)
    local btn = Create("TextButton", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = UI_CONFIG.Font,
        Text = text,
        TextColor3 = color,
        TextSize = 14,
        Parent = frame
    })
    return frame, btn
end

local LagBtnFrame, LagBtn = CreateButton("Lag the Server!", Color3.fromRGB(180, 255, 210))
LagBtnFrame.Parent = Content

local StopBtnFrame, StopBtn = CreateButton("Stop the Spamming", Color3.fromRGB(120, 220, 160))
StopBtnFrame.Parent = Content

-- FOOTER
Create("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 0, 1, -25),
    Size = UDim2.new(1, 0, 0, 20),
    Font = Enum.Font.Code,
    Text = "Press U to toggle | L to toggle lag | DELETE to close",
    TextColor3 = Color3.fromRGB(160, 220, 190),
    TextSize = 10,
    Parent = MainFrame
})

-- LOGIC
local LagEnabled = false

LagBtn.MouseButton1Click:Connect(function()
    LagEnabled = true
    LagBtn.Text = "Lagging..."
    task.spawn(function()
        while LagEnabled do
            local basePackets = math.floor(sliderValue * 10000)
            local variance = math.random(-200, 200)
            PktsLabel.Text = (basePackets + variance) .. "/s"
            task.wait(0.1)
        end
    end)
end)

StopBtn.MouseButton1Click:Connect(function()
    LagEnabled = false
    LagBtn.Text = "Lag the Server!"
    PktsLabel.Text = "0/s"
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Delete then
        ScreenGui:Destroy()
    elseif input.KeyCode == Enum.KeyCode.U then
        MainFrame.Visible = not MainFrame.Visible
    elseif input.KeyCode == Enum.KeyCode.L then
        LagEnabled = not LagEnabled
        LagBtn.Text = LagEnabled and "Lagging..." or "Lag the Server!"
    end
end)
