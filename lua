local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZerosLuckyBlockEditor"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 155)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(18, 35, 60)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 14)
frameCorner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Zeros Lucky Block Editor"
title.TextColor3 = Color3.fromRGB(200, 220, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 17
title.Parent = frame

local luckyText = Instance.new("TextBox")
luckyText.Size = UDim2.new(0.9, 0, 0, 32)
luckyText.Position = UDim2.new(0.05, 0, 0.3, 0)
luckyText.BackgroundColor3 = Color3.fromRGB(30, 55, 90)
luckyText.TextColor3 = Color3.fromRGB(255, 255, 255)
luckyText.Font = Enum.Font.Gotham
luckyText.TextSize = 15
luckyText.ClearTextOnFocus = false
luckyText.PlaceholderText = "Enter Lucky Block"
luckyText.Text = ""
luckyText.Parent = frame

local tbCorner = Instance.new("UICorner")
tbCorner.CornerRadius = UDim.new(0, 10)
tbCorner.Parent = luckyText

local button = Instance.new("TextButton")
button.Size = UDim2.new(0.5, 0, 0, 32)
button.Position = UDim2.new(0.25, 0, 0.58, 0)
button.BackgroundColor3 = Color3.fromRGB(45, 95, 180)
button.Text = "Edit"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.GothamBold
button.TextSize = 15
button.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 10)
btnCorner.Parent = button

local note = Instance.new("TextLabel")
note.Size = UDim2.new(1, -20, 0, 22)
note.Position = UDim2.new(0, 10, 1, -26)
note.BackgroundTransparency = 1
note.Text = ""
note.Font = Enum.Font.GothamBold
note.TextSize = 14
note.TextTransparency = 1
note.Parent = frame

local dragging = false
local dragStart
local startPos
local activeInput

local function updateDrag(input)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		activeInput = input
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
				activeInput = nil
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input == activeInput then
		updateDrag(input)
	end
end)

local blocks = {
	["Secret Lucky Block"] = "La Secret Combinasion",
	["Festive Lucky Block"] = "La Ginger Sekolah",
	["Premium Festive Lucky Block"] = "La Ginger Sekolah",
	["Spooky Lucky Block"] = "La Casa Boo",
	["Taco Lucky Block"] = "Burrito Bandito",
	["Los Taco Blocks"] = "Los Burritos",
	["Los Lucky Blocks"] = "Los 67",
	["Admin Lucky Block"] = "La Grande Combinasion"
}

local function showNote(text, color)
	note.Text = text
	note.TextColor3 = color
	note.TextTransparency = 0
	task.delay(3.5, function()
		note.TextTransparency = 1
		note.Text = ""
	end)
end

button.Activated:Connect(function()
	local name = luckyText.Text
	if name == "" or not blocks[name] then
		showNote("Not Supported", Color3.fromRGB(255, 80, 80))
		return
	end
	for blockName, secondArg in pairs(blocks) do
		local chance = "0.5"
		if blockName == name then
			chance = "9999999999999"
		end
		pcall(function()
			ReplicatedStorage:WaitForChild("Packages")
				:WaitForChild("Net")
				:WaitForChild("RF/AdminService/SetLuckyBlockChance")
				:InvokeServer(blockName, secondArg, chance)
		end)
	end
	showNote("Success", Color3.fromRGB(80, 255, 120))
end)



