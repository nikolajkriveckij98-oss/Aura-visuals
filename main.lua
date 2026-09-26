-- Aura Visuals | Delta Executor
-- Упрощённое меню, но рабочие функции

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- ============ НАСТРОЙКИ ЯЗЫКА ============
local Language = "en"
local Strings = {
    en = {
        title = "Aura Visuals",
        world = "World",
        settings = "Settings",
        particles = "Particles",
        particleSize = "Particle Size",
        particleColor = "Particle Color",
        sky = "Sky",
        skyColor = "Sky Color",
        skyPresets = "Sky Presets",
        defaultSky = "Default",
        spaceSky = "Space / Stars",
        starSky = "Tom 618 Star",
        aurora = "Aurora Borealis",
        fallingStars = "Falling Stars",
        language = "Language",
        english = "English",
        russian = "Русский",
        on = "ON",
        off = "OFF",
    },
    ru = {
        title = "Aura Visuals",
        world = "Мир",
        settings = "Настройки",
        particles = "Частицы",
        particleSize = "Размер частиц",
        particleColor = "Цвет частиц",
        sky = "Небо",
        skyColor = "Цвет неба",
        skyPresets = "Пресеты неба",
        defaultSky = "Обычное",
        spaceSky = "Космос / Звёзды",
        starSky = "Звезда Том 618",
        aurora = "Северное сияние",
        fallingStars = "Падающие звёзды",
        language = "Язык",
        english = "English",
        russian = "Русский",
        on = "ВКЛ",
        off = "ВЫКЛ",
    }
}

local function T(key)
    return Strings[Language][key] or key
end

-- ============ СОСТОЯНИЕ ============
local State = {
    particleSize = 1,
    particleColor = Color3.fromRGB(255, 255, 255),
    skyColor = Color3.fromRGB(0, 0, 0),
    skyPreset = "default",
    auroraEnabled = false,
    fallingStarsEnabled = false,
    particleEmitter = nil,
    auroraPart = nil,
    auroraEmitter = nil,
    sky = nil,
    originalSky = nil,
}

-- ============ СОЗДАНИЕ GUI ============
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AuraVisuals"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Главное окно
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 340)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(80, 80, 120)
UIStroke.Thickness = 1
UIStroke.Parent = MainFrame

-- Заголовок
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = T("title")
TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = TitleBar

-- Закрыть
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 150, 150)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- Кнопки вкладок
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -20, 0, 30)
TabBar.Position = UDim2.new(0, 10, 0, 45)
TabBar.BackgroundTransparency = 1
TabBar.Parent = MainFrame

local WorldTabBtn = Instance.new("TextButton")
WorldTabBtn.Size = UDim2.new(0.5, -5, 1, 0)
WorldTabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
WorldTabBtn.Text = T("world")
WorldTabBtn.TextColor3 = Color3.fromRGB(200, 200, 255)
WorldTabBtn.TextSize = 14
WorldTabBtn.Font = Enum.Font.GothamMedium
WorldTabBtn.Parent = TabBar

local WorldCorner = Instance.new("UICorner")
WorldCorner.CornerRadius = UDim.new(0, 8)
WorldCorner.Parent = WorldTabBtn

local SettingsTabBtn = Instance.new("TextButton")
SettingsTabBtn.Size = UDim2.new(0.5, -5, 1, 0)
SettingsTabBtn.Position = UDim2.new(0.5, 5, 0, 0)
SettingsTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
SettingsTabBtn.Text = T("settings")
SettingsTabBtn.TextColor3 = Color3.fromRGB(150, 150, 180)
SettingsTabBtn.TextSize = 14
SettingsTabBtn.Font = Enum.Font.GothamMedium
SettingsTabBtn.Parent = TabBar

local SettingsCorner = Instance.new("UICorner")
SettingsCorner.CornerRadius = UDim.new(0, 8)
SettingsCorner.Parent = SettingsTabBtn

-- Контейнер контента
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -130)
ContentFrame.Position = UDim2.new(0, 10, 0, 80)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- ============ WORLD TAB ============
local WorldPage = Instance.new("ScrollingFrame")
WorldPage.Size = UDim2.new(1, 0, 1, 0)
WorldPage.BackgroundTransparency = 1
WorldPage.ScrollBarThickness = 4
WorldPage.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 150)
WorldPage.Parent = ContentFrame

local WorldLayout = Instance.new("UIListLayout")
WorldLayout.Padding = UDim.new(0, 8)
WorldLayout.SortOrder = Enum.SortOrder.LayoutOrder
WorldLayout.Parent = WorldPage

-- Секция частиц
local function CreateLabel(parent, text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 24)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(180, 180, 220)
    lbl.TextSize = 14
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = parent
    return lbl
end

local function CreateSlider(parent, name, min, max, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundTransparency = 1
    container.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. default
    label.TextColor3 = Color3.fromRGB(180, 180, 220)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, 0, 0, 6)
    track.Position = UDim2.new(0, 0, 0, 30)
    track.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    track.BorderSizePixel = 0
    track.Parent = container

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
    fill.BorderSizePixel = 0
    fill.Parent = track

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 20)
    btn.Position = UDim2.new(0, 0, 0, 25)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = container

    local dragging = false

    local function update(input)
        local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * pos + 0.5)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        label.Text = name .. ": " .. value
        callback(value)
    end

    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return container
end

CreateLabel(WorldPage, T("particles"))

CreateSlider(WorldPage, T("particleSize"), 0, 5, 1, function(v)
    State.particleSize = v
    if State.particleEmitter then
        State.particleEmitter.Size = NumberSequence.new(v)
    end
end)

-- Кнопка выбора цвета частиц
local ParticleColorBtn = Instance.new("TextButton")
ParticleColorBtn.Size = UDim2.new(1, 0, 0, 32)
ParticleColorBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
ParticleColorBtn.Text = T("particleColor")
ParticleColorBtn.TextColor3 = Color3.fromRGB(200, 200, 240)
ParticleColorBtn.TextSize = 13
ParticleColorBtn.Font = Enum.Font.Gotham
ParticleColorBtn.Parent = WorldPage

local PcCorner = Instance.new("UICorner")
PcCorner.CornerRadius = UDim.new(0, 6)
PcCorner.Parent = ParticleColorBtn

ParticleColorBtn.MouseButton1Click:Connect(function()
    -- Простой циклический перебор цветов
    local colors = {
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(255, 100, 100),
        Color3.fromRGB(100, 255, 100),
        Color3.fromRGB(100, 100, 255),
        Color3.fromRGB(255, 255, 100),
        Color3.fromRGB(255, 100, 255),
        Color3.fromRGB(100, 255, 255),
    }
    local currentIdx = 1
    for i, c in ipairs(colors) do
        if c == State.particleColor then
            currentIdx = i
            break
        end
    end
    local nextIdx = currentIdx % #colors + 1
    State.particleColor = colors[nextIdx]
    ParticleColorBtn.BackgroundColor3 = State.particleColor
    if State.particleEmitter then
        State.particleEmitter.Color = ColorSequence.new(State.particleColor)
    end
end)

-- ============ СОЗДАНИЕ ЧАСТИЦ ============
local function CreateParticleEmitter()
    if State.particleEmitter then
        State.particleEmitter:Destroy()
    end

    local part = Instance.new("Part")
    part.Name = "AuraParticlePart"
    part.Size = Vector3.new(1, 1, 1)
    part.Transparency = 1
    part.Anchored = true
    part.CanCollide = false
    part.CanQuery = false
    part.CanTouch = false
    part.Position = Vector3.new(0, 20, 0)
    part.Parent = Workspace

    local emitter = Instance.new("ParticleEmitter")
    emitter.Name = "AuraParticles"
    emitter.Texture = "rbxassetid://243098098" -- стандартная текстура искры
    emitter.Rate = 20
    emitter.Lifetime = NumberRange.new(3, 5)
    emitter.Speed = NumberRange.new(2, 5)
    emitter.SpreadAngle = Vector2.new(180, 180)
    emitter.Size = NumberSequence.new(State.particleSize)
    emitter.Color = ColorSequence.new(State.particleColor)
    emitter.LightEmission = 0.5
    emitter.Parent = part

    State.particleEmitter = emitter
    return part
end

CreateParticleEmitter()

-- ============ НЕБО ============
CreateLabel(WorldPage, T("sky"))

local function SetSkyColor(color)
    State.skyColor = color
    Lighting.Ambient = color
    Lighting.OutdoorAmbient = color
    if Lighting:FindFirstChildOfClass("Atmosphere") then
        Lighting:FindFirstChildOfClass("Atmosphere").Color = color
    end
end

local SkyColorBtn = Instance.new("TextButton")
SkyColorBtn.Size = UDim2.new(1, 0, 0, 32)
SkyColorBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
SkyColorBtn.Text = T("skyColor")
SkyColorBtn.TextColor3 = Color3.fromRGB(200, 200, 240)
SkyColorBtn.TextSize = 13
SkyColorBtn.Font = Enum.Font.Gotham
SkyColorBtn.Parent = WorldPage

local ScCorner = Instance.new("UICorner")
ScCorner.CornerRadius = UDim.new(0, 6)
ScCorner.Parent = SkyColorBtn

SkyColorBtn.MouseButton1Click:Connect(function()
    local colors = {
        Color3.fromRGB(0, 0, 0),
        Color3.fromRGB(50, 50, 80),
        Color3.fromRGB(100, 50, 80),
        Color3.fromRGB(50, 100, 80),
        Color3.fromRGB(80, 80, 150),
        Color3.fromRGB(150, 100, 50),
    }
    local currentIdx = 1
    for i, c in ipairs(colors) do
        if c == State.skyColor then
            currentIdx = i
            break
        end
    end
    local nextIdx = currentIdx % #colors + 1
    SetSkyColor(colors[nextIdx])
    SkyColorBtn.BackgroundColor3 = State.skyColor
end)

-- Пресеты неба
local SkyPresets = {
    { name = "default", labelKey = "defaultSky" },
    { name = "space", labelKey = "spaceSky", skybox = "rbxassetid://159454299" },
    { name = "star", labelKey = "starSky", skybox = "rbxassetid://159454299" },
}

for _, preset in ipairs(SkyPresets) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    btn.Text = T(preset.labelKey)
    btn.TextColor3 = Color3.fromRGB(180, 180, 220)
    btn.TextSize = 13
    btn.Font = Enum.Font.Gotham
    btn.Parent = WorldPage

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn

    btn.MouseButton1Click:Connect(function()
        if State.sky then
            State.sky:Destroy()
        end

        if preset.name == "default" then
            State.sky = nil
            Lighting.Ambient = Color3.fromRGB(128, 128, 128)
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        else
            local sky = Instance.new("Sky")
            sky.SkyboxBk = preset.skybox
            sky.SkyboxDn = preset.skybox
            sky.SkyboxFt = preset.skybox
            sky.SkyboxLf = preset.skybox
            sky.SkyboxRt = preset.skybox
            sky.SkyboxUp = preset.skybox
            sky.Parent = Lighting
            State.sky = sky
            SetSkyColor(Color3.fromRGB(0, 0, 0))
        end
    end)
end

-- ============ СЕВЕРНОЕ СИЯНИЕ ============
CreateLabel(WorldPage, T("aurora"))

local AuroraBtn = Instance.new("TextButton")
AuroraBtn.Size = UDim2.new(1, 0, 0, 32)
AuroraBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
AuroraBtn.Text = T("aurora") .. ": " .. T("off")
AuroraBtn.TextColor3 = Color3.fromRGB(200, 200, 240)
AuroraBtn.TextSize = 13
AuroraBtn.Font = Enum.Font.Gotham
AuroraBtn.Parent = WorldPage

local AcCorner = Instance.new("UICorner")
AcCorner.CornerRadius = UDim.new(0, 6)
AcCorner.Parent = AuroraBtn

AuroraBtn.MouseButton1Click:Connect(function()
    State.auroraEnabled = not State.auroraEnabled
    AuroraBtn.Text = T("aurora") .. ": " .. (State.auroraEnabled and T("on") or T("off"))

    if State.auroraEnabled then
        if not State.auroraPart then
            local part = Instance.new("Part")
            part.Name = "AuroraPart"
            part.Size = Vector3.new(1, 1, 1)
            part.Transparency = 1
            part.Anchored = true
            part.CanCollide = false
            part.CanQuery = false
            part.CanTouch = false
            part.Position = Vector3.new(0, 500, 0)
            part.Orientation = Vector3.new(0, 0, -90)
            part.Parent = Workspace

            local emitter = Instance.new("ParticleEmitter")
            emitter.Name = "AuroraEmitter"
            emitter.Texture = "rbxassetid://110170832236629"
            emitter.Brightness = 1
            emitter.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(141, 255, 133)),
                ColorSequenceKeypoint.new(0.25, Color3.fromRGB(233, 255, 241)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(165, 243, 255)),
                ColorSequenceKeypoint.new(0.75, Color3.fromRGB(108, 255, 120)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(141, 255, 133)),
            })
            emitter.LightInfluence = 0
            emitter.LightEmission = 1
            emitter.Drag = 9
            emitter.SpreadAngle = Vector2.new(180, 0)
            emitter.Speed = NumberRange.new(10000, 10000)
            emitter.Lifetime = NumberRange.new(2, 4)
            emitter.Rate = 200
            emitter.Size = NumberSequence.new(600)
            emitter.Squash = NumberSequence.new(2)
            emitter.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
            emitter.Parent = part

            State.auroraPart = part
            State.auroraEmitter = emitter

            -- Следим за камерой, чтобы сияние было видно
            local camera = Workspace.CurrentCamera
            RunService.RenderStepped:Connect(function()
                if State.auroraPart and State.auroraPart.Parent then
                    State.auroraPart.Position = camera.CFrame.Position + Vector3.new(0, 200, 0)
                end
            end)
        end
    else
        if State.auroraPart then
            State.auroraPart:Destroy()
            State.auroraPart = nil
            State.auroraEmitter = nil
        end
    end
end)

-- ============ SETTINGS TAB ============
local SettingsPage = Instance.new("Frame")
SettingsPage.Size = UDim2.new(1, 0, 1, 0)
SettingsPage.BackgroundTransparency = 1
SettingsPage.Visible = false
SettingsPage.Parent = ContentFrame

local SettingsLayout = Instance.new("UIListLayout")
SettingsLayout.Padding = UDim.new(0, 8)
SettingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
SettingsLayout.Parent = SettingsPage

CreateLabel(SettingsPage, T("language"))

local LangEnBtn = Instance.new("TextButton")
LangEnBtn.Size = UDim2.new(1, 0, 0, 36)
LangEnBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
LangEnBtn.Text = "English"
LangEnBtn.TextColor3 = Color3.fromRGB(200, 200, 240)
LangEnBtn.TextSize = 14
LangEnBtn.Font = Enum.Font.Gotham
LangEnBtn.Parent = SettingsPage

local LeCorner = Instance.new("UICorner")
LeCorner.CornerRadius = UDim.new(0, 6)
LeCorner.Parent = LangEnBtn

local LangRuBtn = Instance.new("TextButton")
LangRuBtn.Size = UDim2.new(1, 0, 0, 36)
LangRuBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
LangRuBtn.Text = "Русский"
LangRuBtn.TextColor3 = Color3.fromRGB(180, 180, 220)
LangRuBtn.TextSize = 14
LangRuBtn.Font = Enum.Font.Gotham
LangRuBtn.Parent = SettingsPage

local LrCorner = Instance.new("UICorner")
LrCorner.CornerRadius = UDim.new(0, 6)
LrCorner.Parent = LangRuBtn

local function RefreshLanguage()
    TitleLabel.Text = T("title")
    WorldTabBtn.Text = T("world")
    SettingsTabBtn.Text = T("settings")
    AuroraBtn.Text = T("aurora") .. ": " .. (State.auroraEnabled and T("on") or T("off"))
end

LangEnBtn.MouseButton1Click:Connect(function()
    Language = "en"
    RefreshLanguage()
end)

LangRuBtn.MouseButton1Click:Connect(function()
    Language = "ru"
    RefreshLanguage()
end)

-- ============ ПЕРЕКЛЮЧЕНИЕ ВКЛАДОК ============
WorldTabBtn.MouseButton1Click:Connect(function()
    WorldPage.Visible = true
    SettingsPage.Visible = false
    WorldTabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
    SettingsTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
end)

SettingsTabBtn.MouseButton1Click:Connect(function()
    WorldPage.Visible = false
    SettingsPage.Visible = true
    WorldTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    SettingsTabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ============ ПАДАЮЩИЕ ЗВЁЗДЫ ============
CreateLabel(WorldPage, T("fallingStars"))

local FallingStarsBtn = Instance.new("TextButton")
FallingS