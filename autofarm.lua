local autofarm = false
local burger_done = false
local fries_done = false
local soda_done = false
local ingredients_path
local ingredients = {}
local autofarm_time = 5
local autokick = false
local image_to_object = {
    ["rbxassetid://14358866788"] = "patty_left",
    ["rbxassetid://14358886220"] = "patty_right",
    ["rbxassetid://14358865402"] = "lettuce",
    ["rbxassetid://14358884748"] = "tomato",
    ["rbxassetid://14358880695"] = "cheese",
    ["rbxassetid://14467423053"] = "fries",
    ["rbxassetid://14467425084"] = "soda",
    ["rbxassetid://14467509651"] = "moz_sticks",
    ["rbxassetid://14358878251"] = "onion",
    ["rbxassetid://14467511580"] = "onion_rings",
    ["rbxassetid://9555980177"] = "fruit_juice",
    ["rbxassetid://1588110682"] = "milkshake"
}

local drink_path
local side_path 
local tabs_path
local time_started = 0
local width
local height

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MyEpicGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- UI corner function
local function roundify(obj, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = obj
end

-- Main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 180)
frame.Position = UDim2.new(0.5, -150, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
frame.BorderSizePixel = 0
frame.Parent = screenGui
roundify(frame, 12)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Autofarm Menu"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = frame

-- Autofarm Button
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0.5, -100, 0.5, -10)
button.Text = "OFF"
button.BackgroundColor3 = Color3.fromRGB(255, 65, 65)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.GothamBold
button.TextSize = 18
button.AutoButtonColor = false
button.Parent = frame
roundify(button, 10)    

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 16
closeButton.Parent = frame
roundify(closeButton, 8)


local autoKickEnabled = false

local autoKickCheck = Instance.new("TextButton")
autoKickCheck.Size = UDim2.new(0, 25, 0, 25)
autoKickCheck.Position = UDim2.new(0, 20, 1, -35)
autoKickCheck.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
autoKickCheck.Text = ""
autoKickCheck.Parent = frame
autoKickCheck.AutoButtonColor = false
roundify(autoKickCheck, 6)

local checkmark = Instance.new("TextLabel")
checkmark.Size = UDim2.new(1, 0, 1, 0)
checkmark.Position = UDim2.new(0, 0, 0, 0)
checkmark.Text = ""
checkmark.TextColor3 = Color3.fromRGB(0, 255, 0)
checkmark.Font = Enum.Font.GothamBold
checkmark.TextSize = 20
checkmark.BackgroundTransparency = 1
checkmark.Parent = autoKickCheck

local autoKickLabel = Instance.new("TextLabel")
autoKickLabel.Size = UDim2.new(0, 100, 0, 25)
autoKickLabel.Position = UDim2.new(0, 50, 1, -35)
autoKickLabel.Text = "AutoKick"
autoKickLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
autoKickLabel.BackgroundTransparency = 1
autoKickLabel.Font = Enum.Font.Gotham
autoKickLabel.TextSize = 16
autoKickLabel.TextXAlignment = Enum.TextXAlignment.Left
autoKickLabel.Parent = frame

autoKickCheck.MouseButton1Click:Connect(function()
	autokick = not autokick
	checkmark.Text = autokick and "✔" or ""
end)


button.MouseButton1Click:Connect(function()
	if not autofarm then
		button.Text = "ON"
		autofarm = true
		button.BackgroundColor3 = Color3.fromRGB(85, 255, 85)
		StartLoop()
	else
		button.Text = "OFF"
		autofarm = false
		button.BackgroundColor3 = Color3.fromRGB(255, 65, 65)

		ingredients_path = nil
		ingredients = {}
		drink_path = nil
		side_path = nil
		tabs_path = nil
		time_started = 0
	end
end)


function Load_items()
    local succ, err = pcall(function()
        ingredients.bottom_bun = ingredients_path["Bottom Bun [Raw]"].Button.AbsolutePosition
        ingredients.cheese = ingredients_path["Cheese [Chopped]"].Button.AbsolutePosition
        ingredients.lettuce = ingredients_path["Lettuce [Chopped]"].Button.AbsolutePosition
        ingredients.patty_left = ingredients_path["Meat Patty [Cooked]"].Button.AbsolutePosition
        ingredients.onion = ingredients_path["Onion [Chopped]"].Button.AbsolutePosition
        ingredients.patty_right = ingredients_path["Plantbased Patty [Cooked]"].Button.AbsolutePosition
        ingredients.tomato = ingredients_path["Tomato [Chopped]"].Button.AbsolutePosition
        ingredients.top_bun = ingredients_path["Top Bun [Raw]"].Button.AbsolutePosition

        ingredients.d_s = drink_path:FindFirstChild("Size").Small.AbsolutePosition
        ingredients.d_m = drink_path:FindFirstChild("Size").Medium.AbsolutePosition
        ingredients.d_l = drink_path:FindFirstChild("Size").Large.AbsolutePosition
        ingredients.soda = drink_path.Type["Fountain Drink"].AbsolutePosition
        ingredients.fruit_juice = drink_path.Type["FruityFruit Juice"].AbsolutePosition
        ingredients.milkshake = drink_path.Type["Vanilla Milkshake"].AbsolutePosition

        ingredients.s_s = side_path:FindFirstChild("Size").Small.AbsolutePosition
        ingredients.s_m = side_path:FindFirstChild("Size").Medium.AbsolutePosition
        ingredients.s_l = side_path:FindFirstChild("Size").Large.AbsolutePosition
        ingredients.fries = side_path.Type["Fries [Ready]"].AbsolutePosition
        ingredients.moz_sticks = side_path.Type["Mozarella Sticks [Ready]"].AbsolutePosition
        ingredients.onion_rings = side_path.Type["Onion Rings [Ready]"].AbsolutePosition

        ingredients.burger_tab = tabs_path["Burger"].AbsolutePosition
        ingredients.confirm = tabs_path["Confirm"].AbsolutePosition
        ingredients.drink_tab = tabs_path["Drink"].AbsolutePosition
        ingredients.side_tab = tabs_path["Side"].AbsolutePosition
    end)
    if not succ then
        Notify("Script Error!", "An error has occurred when trying to update item positions.", "rbxassetid://4519042263")
    end
end



function LoadResources()
    if #ingredients <= 0 then
        Notify('Trwa wczytywanie zasobow...')
        repeat
            wait(1)
            local success, errorOrResult = pcall(function()
                ingredients_path = game:GetService("Players").LocalPlayer.PlayerGui.MainGUI.CashierFrame.Background.InnerBackground.Pages.Burger.Ingredients
            end)
        until ingredients_path
        
        drink_path = game:GetService("Players").LocalPlayer.PlayerGui.MainGUI.CashierFrame.Background.InnerBackground.Pages.Drink
        side_path = game:GetService("Players").LocalPlayer.PlayerGui.MainGUI.CashierFrame.Background.InnerBackground.Pages.Side
        tabs_path = game:GetService("Players").LocalPlayer.PlayerGui.MainGUI.CashierFrame.Background.InnerBackground.Tabs

        width = ingredients_path["Tomato [Chopped]"].Button.AbsoluteSize.X / 2
        height = ingredients_path["Tomato [Chopped]"].Button.AbsoluteSize.Y / 2
        Load_items()
        time_started = os.time()
        Notify('Wczytano, skrypt moze dzialac juz samemu :)')
    end

end


function StartLoop()
    LoadResources()
    while autofarm do
        task.wait(.25)
        local order, amount, order_place = Find_order()
        if order ~= false then
            if order_place == "1" then
                if burger_done == false then
                    Load_items()
                    Click("bottom_bun")
                    for i, v in order do
                        for i = 1, amount[i]:match("%d+") do
                            Click(image_to_object[v])
                        end
                    end
                    Click("top_bun")
                    burger_done = true
                end
            end
            if order_place == "2" then
                if fries_done == false then
                    local captured_order = order[1]
                    local captured_amount = amount[1]
                    Click("side_tab")
                    task.wait(1.3)
                    Load_items()
                    Click(image_to_object[captured_order])
                    Click_size(captured_amount, "s")
                    fries_done = true
                end
            end
            if order_place == "3" then
                if soda_done == false then
                    local captured_order = order[1]
                    local captured_amount = amount[1]
                    Click("drink_tab")
                    task.wait(1.3)
                    Load_items()
                    Click(image_to_object[captured_order])
                    Click_size(captured_amount, "d")
                    soda_done = true
                end
            end
            order, amount, order_place = Find_order()

            if autokick then
                if os.time() - time_started > (autofarm_time * 3600) then
                    return game.Players.LocalPlayer:Kick("Zostałeś wyrzucony autmatycznie, z powodu na maksymalna ilosc dopuszczalana na autofarmie z powodu na podejrzenia ROBLOX odnosnie makr przepracowałes: "..tostring(autofarm_time).." hours! Hope you enjoyed!")
                end
            end
        else
            if burger_done == true then
                Click("confirm")
                burger_done = false
                fries_done = false
                soda_done = false
                task.wait(3.4)
            end
        end
    end
end


closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local dragging = false
local dragInput, mousePos, framePos

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		mousePos = input.Position
		framePos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - mousePos
		frame.Position = UDim2.new(
			framePos.X.Scale, framePos.X.Offset + delta.X,
			framePos.Y.Scale, framePos.Y.Offset + delta.Y
		)
	end
end)






function Click(object)
    if ingredients[object] then
        local Pos1 = ingredients[object].X + width
        local Pos2 = ingredients[object].Y + (height * 2)
        local wait_time = 0.15 + math.random() * 0.4
        if Pos1 and Pos2 then
            print("Clicking "..object.." at "..tostring(Pos1).." "..tostring(Pos2)..". Wait time: "..tostring(wait_time))
            task.wait(wait_time)
            local vim = game:GetService('VirtualInputManager')
            vim:SendMouseButtonEvent(Pos1, Pos2, 0, true, game, 0)
            wait()
            vim:SendMouseButtonEvent(Pos1, Pos2, 0, false, game, 0)
        else
            warn("Invalid positions for "..object)
        end
    else
        warn("Object not found in the ingredients table. ("..tostring(object)..")")
    end
end


function Find_order()
    local order = {}
    local amount = {}
    local order_place
    for i, character in workspace._game.SpawnedCharacters:GetChildren() do
        if character.Name == "BloxBurgersCustomer" then
            if character.Head:FindFirstChild("ChatBubble") then
                for i, head in character.Head.ChatBubble.Body.IconFrame:GetChildren() do
                    order_place = head.Name
                    if head:IsA("Frame") then
                        for i, frame in head:GetChildren() do
                            if frame:IsA("ImageLabel") then
                                if frame.Image ~= "rbxassetid://2037427845" then
                                    table.insert(order, frame.Image)
                                    local success, value = pcall(function()
                                        table.insert(amount, frame.Amount.TextLabel.Text)
                                    end)
                                    if not success then
                                        table.insert(amount, frame:FindFirstChild("Size").TextLabel.Text)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    if #order > 0 then
        return order, amount, order_place
    else
        return false
    end
end

function Click_size(size, type)
    local prefix = (type:lower() == "s") and "s_" or "d_"
    Click(prefix .. size:lower())
end

function Notify(msg)
    game.StarterGui:SetCore("SendNotification",{
        Title = 'kariee autofarm';
        Text = msg;
        Icon = "rbxassetid://6031097225",
        Duration = 5;
    })
end

function Notify2(title, msg, icon)
    game.StarterGui:SetCore("SendNotification",{
        Title = title;
        Text = msg;
        Icon = icon;
        Duration = 5;
    })
end
