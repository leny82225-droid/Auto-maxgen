-- Roblox Auto Job BedilPusat - Terbatas & Aman (Delta Mobile Exec)

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local isRunning = false

-- Fungsi Teleportasi yang Dibatasi (Memakai Jeda & Jarak Aman)
local function tpToLimited(targetPart)
    if not targetPart or not targetPart:IsA("BasePart") then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    
    -- Teleportasi Mobil jika sedang di DriveSeat
    if humanoid and humanoid.SeatPart and humanoid.SeatPart:IsA("VehicleSeat") then
        local vehicle = humanoid.SeatPart.Parent
        if vehicle and vehicle:IsA("Model") then
            -- Beri sedikit jeda waktu sebelum jalan
            task.wait(0.3)
            vehicle:PivotTo(targetPart.CFrame * CFrame.new(0, 3, 0))
            task.wait(0.5) -- Jeda setelah teleport agar fisik mobil stabil
            return
        end
    end
    
    -- Teleportasi Karakter
    if root then
        root.CFrame = targetPart.CFrame * CFrame.new(0, 3, 0)
    end
end

-- Mencari Folder Utama BedilPusat
local function getBedilFolder()
    for _, child in pairs(Workspace:GetChildren()) do
        local lowerName = string.lower(child.Name)
        if string.find(lowerName, "bedil") then
            return child
        end
    end
    return nil
end

-- Deteksi Target Acak yang Sedang Aktif
local function getActiveTarget()
    local bedil = getBedilFolder()
    if not bedil then return nil end
    
    local deliveryTargets = bedil:FindFirstChild("DeliveryTargets")
    if not deliveryTargets then return nil end
    
    for _, target in pairs(deliveryTargets:GetChildren()) do
        if target:IsA("BasePart") then
            for _, desc in pairs(target:GetDescendants()) do
                if (desc:IsA("BillboardGui") or desc:IsA("Beam")) and desc.Enabled then
                    return target
                end
            end
            if target.Transparency < 1 then
                return target
            end
        end
    end
    
    return deliveryTargets:FindFirstChildOfClass("Part")
end

-- Logic Auto Job
local function startBedilJob()
    task.spawn(function()
        while isRunning do
            local bedil = getBedilFolder()
            
            if bedil then
                -- 1. Ambil Job
                local jobPart = bedil:FindFirstChild("Job")
                if jobPart then
                    tpToLimited(jobPart)
                    task.wait(2.5) -- Waktu jeda dipanjangin sedikit agar tidak terlalu ngebut
                end
                
                if not isRunning then break end
                
                -- 2. Ke Target Antar
                local targetPart = getActiveTarget()
                if targetPart then
                    tpToLimited(targetPart)
                    task.wait(2.5)
                end
                
                if not isRunning then break end
                
                -- 3. Ke Finish
                local finishPart = bedil:FindFirstChild("Finish")
                if finishPart then
                    tpToLimited(finishPart)
                    task.wait(2.5)
                end
            end
            
            task.wait(1.5)
        end
    end)
end

-- GUI Mengambang
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "BedilAutoJobGui"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 150, 0, 75)
Frame.Position = UDim2.new(0.05, 0, 0.35, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Active = true
Frame.Draggable = true

local Corner = Instance.new("UICorner", Frame)
Corner.CornerRadius = UDim.new(0, 8)

local Btn = Instance.new("TextButton", Frame)
Btn.Size = UDim2.new(0.85, 0, 0.6, 0)
Btn.Position = UDim2.new(0.075, 0, 0.2, 0)
Btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Btn.Text = "BEDIL: OFF"
Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn.Font = Enum.Font.SourceSansBold
Btn.TextSize = 15

local BtnCorner = Instance.new("UICorner", Btn)
BtnCorner.CornerRadius = UDim.new(0, 6)

Btn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    if isRunning then
        Btn.Text = "BEDIL: ON"
        Btn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        startBedilJob()
    else
        Btn.Text = "BEDIL: OFF"
        Btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)
