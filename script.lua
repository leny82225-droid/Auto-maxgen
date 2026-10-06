-- Delta GUI Auto Job MAXGEN (Clarity Reboot Style)
-- Owner: brukontop

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local Title = Instance.new("TextLabel")

ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.05, 0, 0.35, 0)
MainFrame.Size = UDim2.new(0, 190, 0, 110)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Text = "MAXGEN AUTO JOB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 14

ToggleButton.Parent = MainFrame
ToggleButton.Text = "AUTO JOB: OFF"
ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Position = UDim2.new(0.1, 0, 0.45, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0.4, 0)
ToggleButton.Font = Enum.Font.SourceSansBold

local isRunning = false

-- Safe Noclip khusus karakter
local function applyNoclip(char)
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

-- Fungsi Jalan Halus (Tween)
local function tweenTo(targetCFrame, speed)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    
    applyNoclip(char)
    
    local distance = (root.Position - targetCFrame.Position).Magnitude
    local duration = distance / (speed or 35)
    
    local tween = TweenService:Create(root, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    tween:Play()
    tween.Completed:Wait()
end

-- Cari Lokasi Tanda Kuning (DeliveryBeam / DummyTarget / BedilPusat)
local function findJobTarget()
    -- 1. Cek DeliveryBeam
    local beam = Workspace:FindFirstChild("DeliveryBeam", true)[span_0](start_span)[span_0](end_span)[span_1](start_span)[span_1](end_span)[span_2](start_span)[span_2](end_span)
    if beam and beam:IsA("Beam") and beam.Attachment1 then
        return beam.Attachment1.WorldPosition
    end

    -- 2. Cek DummyTarget di Workspace
    for _, obj in pairs(Workspace:GetChildren()) do
        if string.find(obj.Name, "DummyTarget") and obj:IsA("BasePart") then[span_3](start_span)[span_3](end_span)[span_4](start_span)[span_4](end_span)[span_5](start_span)[span_5](end_span)[span_6](start_span)[span_6](end_span)
            return obj.Position
        end
    end

    -- 3. Cek DeliveryTargets di Ekonomi.BedilPusat
    local ekonomi = Workspace:FindFirstChild("Ekonomi")[span_7](start_span)[span_7](end_span)[span_8](start_span)[span_8](end_span)[span_9](start_span)[span_9](end_span)
    if ekonomi then
        local bedil = ekonomi:FindFirstChild("BedilPusat")[span_10](start_span)[span_10](end_span)[span_11](start_span)[span_11](end_span)
        if bedil and bedil:FindFirstChild("DeliveryTargets") then[span_12](start_span)[span_12](end_span)
            local targets = bedil.DeliveryTargets:GetChildren()[span_13](start_span)[span_13](end_span)
            if #targets > 0 then
                return targets[1].Position
            end
        end
    end

    return nil
end

-- Main Loop Auto Job MAXGEN
local function startTikTokAutoJob()
    task.spawn(function()
        while isRunning do
            local targetPos = findJobTarget()
            
            if targetPos then
                -- Jalan ke titik tujuan pengantaran
                tweenTo(CFrame.new(targetPos + Vector3.new(0, 3, 0)), 40)
                
                -- Delay acak agar terlihat alami
                task.wait(math.random(15, 25) / 10)
            else
                -- Jika tidak ada target aktif, balik ke lokasi pendaftaran MAXGEN
                local ekonomi = Workspace:FindFirstChild("Ekonomi")[span_14](start_span)[span_14](end_span)[span_15](start_span)[span_15](end_span)[span_16](start_span)[span_16](end_span)
                if ekonomi and ekonomi:FindFirstChild("BedilPusat") then[span_17](start_span)[span_17](end_span)[span_18](start_span)[span_18](end_span)
                    local startPoint = ekonomi.BedilPusat:FindFirstChild("Job") or ekonomi.BedilPusat:FindFirstChild("Finish")[span_19](start_span)[span_19](end_span)
                    if startPoint then
                        tweenTo(startPoint:GetPivot(), 35)
                    end
                end
                
                task.wait(2)
            end
        end
    end)
end

-- Toggle On/Off
ToggleButton.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    if isRunning then
        ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
        ToggleButton.Text = "AUTO JOB: ON"
        startTikTokAutoJob()
    else
        ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        ToggleButton.Text = "AUTO JOB: OFF"
    end
end)
