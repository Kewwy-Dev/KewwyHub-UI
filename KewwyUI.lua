local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local CoreGui = game:GetService("CoreGui")

local KewwyHub = {}

local Theme = {
    MainGreen = Color3.fromHex("#318F7D"),
    White = Color3.fromHex("#FFFFFF"),
    MainBG = Color3.fromHex("#111314"),
    TopBarBG = Color3.fromHex("#171A1B"),
    ElementBG = Color3.fromHex("#191D1E"),
    TabActiveBG = Color3.fromHex("#D1D5D5"),
    TabInactiveBG = Color3.fromHex("#111314"),
    BoxStroke = Color3.fromHex("#FFFFFF"), 
    DropdownGradient = Color3.fromHex("#1A2B28") 
}

local function CreateAnimatedBorder(parentInstance, cornerRadius)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 3
    stroke.Color = Color3.new(1, 1, 1)
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parentInstance

    if cornerRadius then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = cornerRadius
        corner.Parent = parentInstance
    end

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.MainGreen),
        ColorSequenceKeypoint.new(1, Theme.White)
    })
    gradient.Parent = stroke 

    local rotation = 0
    RunService.RenderStepped:Connect(function(dt)
        rotation = (rotation + (dt * 130)) % 360
        gradient.Rotation = rotation
    end)
    return stroke
end

local function MakeDraggable(dragHandle, objectToMove)
    local dragging, dragInput, dragStart, startPos
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = objectToMove.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            objectToMove.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

function KewwyHub:CreateWindow()
    local WindowInfo = {}
    if CoreGui:FindFirstChild("KewwyHubUI") then
        CoreGui.KewwyHubUI:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "KewwyHubUI"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local ToggleBtn = Instance.new("TextButton", ScreenGui)
    ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
    ToggleBtn.Position = UDim2.new(0, 20, 0, 20)
    ToggleBtn.BackgroundColor3 = Theme.MainBG
    ToggleBtn.Text = "K"
    ToggleBtn.TextColor3 = Theme.MainGreen
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 22
    CreateAnimatedBorder(ToggleBtn, UDim.new(0, 8))
    
    MakeDraggable(ToggleBtn, ToggleBtn)

    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 680, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -340, 0.5, -225)
    MainFrame.BackgroundColor3 = Theme.MainBG
    MainFrame.Active = true
    CreateAnimatedBorder(MainFrame, UDim.new(0, 10))

    local TopBar = Instance.new("Frame", MainFrame)
    TopBar.Size = UDim2.new(1, 0, 0, 45)
    TopBar.BackgroundColor3 = Theme.TopBarBG
    TopBar.BorderSizePixel = 0
    TopBar.Active = true
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)
    
    MakeDraggable(TopBar, MainFrame)

    local TopBarFix = Instance.new("Frame", TopBar)
    TopBarFix.Size = UDim2.new(1, 0, 0, 10)
    TopBarFix.Position = UDim2.new(0, 0, 1, -10)
    TopBarFix.BackgroundColor3 = Theme.TopBarBG
    TopBarFix.BorderSizePixel = 0

    local Title = Instance.new("TextLabel", TopBar)
    Title.AutomaticSize = Enum.AutomaticSize.XY
    Title.Position = UDim2.new(0, 20, 0.5, 0)
    Title.AnchorPoint = Vector2.new(0, 0.5)
    Title.BackgroundTransparency = 1
    Title.Text = "Kewwy Hub"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 22
    
    local TitleGradient = Instance.new("UIGradient", Title)
    TitleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.MainGreen),
        ColorSequenceKeypoint.new(1, Theme.White)
    })

    local CloseBtn = Instance.new("TextButton", TopBar)
    CloseBtn.Size = UDim2.new(0, 28, 0, 28)
    CloseBtn.Position = UDim2.new(1, -35, 0, 8)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Theme.White
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 16 
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

    local LineH = Instance.new("Frame", MainFrame)
    LineH.Size = UDim2.new(1, -30, 0, 1)
    LineH.Position = UDim2.new(0, 15, 0, 46)
    LineH.BackgroundColor3 = Color3.fromRGB(35, 42, 43)
    LineH.BorderSizePixel = 0

    local Sidebar = Instance.new("ScrollingFrame", MainFrame)
    Sidebar.Size = UDim2.new(0, 160, 1, -60)
    Sidebar.Position = UDim2.new(0, 10, 0, 55)
    Sidebar.BackgroundTransparency = 1
    Sidebar.ScrollBarThickness = 0
    local SidebarLayout = Instance.new("UIListLayout", Sidebar)
    SidebarLayout.Padding = UDim.new(0, 6)

    local LineV = Instance.new("Frame", MainFrame)
    LineV.Size = UDim2.new(0, 2, 1, -70)
    LineV.Position = UDim2.new(0, 180, 0, 55)
    LineV.BackgroundColor3 = Theme.MainGreen
    LineV.BorderSizePixel = 0

    local ContentContainer = Instance.new("Frame", MainFrame)
    ContentContainer.Size = UDim2.new(1, -210, 1, -55)
    ContentContainer.Position = UDim2.new(0, 195, 0, 55)
    ContentContainer.BackgroundTransparency = 1

    local isOpen = true
    local function ToggleUI()
        isOpen = not isOpen
        if isOpen then
            MainFrame.Visible = true
            MainFrame.Size = UDim2.new(0, 0, 0, 0)
            MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 680, 0, 450), Position = UDim2.new(0.5, -340, 0.5, -225)}):Play()
        else
            for _, child in pairs(ScreenGui:GetChildren()) do
                if child.Name == "OptionList_Floating" then
                    child.Visible = false
                end
            end
            local t = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)})
            t:Play()
            t.Completed:Wait()
            MainFrame.Visible = false
        end
    end
    ToggleBtn.MouseButton1Click:Connect(ToggleUI)
    CloseBtn.MouseButton1Click:Connect(ToggleUI)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed then
            if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
                ToggleUI()
            end
        end
    end)

    local Tabs = {}
    
    local function BuildElementsAPI(parentFrame)
        local Elements = {}
        local elementCount = 0

        function Elements:CreateSection(text)
            elementCount = elementCount + 1
            local SectionLabel = Instance.new("TextLabel", parentFrame)
            SectionLabel.LayoutOrder = elementCount
            SectionLabel.Size = UDim2.new(1, 0, 0, 30)
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Text = text
            SectionLabel.TextColor3 = Theme.White
            SectionLabel.Font = Enum.Font.GothamMedium
            SectionLabel.TextSize = 15
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
        end

        function Elements:CreateFolder(text)
            elementCount = elementCount + 1
            local FolderFrame = Instance.new("Frame", parentFrame)
            FolderFrame.LayoutOrder = elementCount
            FolderFrame.Size = UDim2.new(1, 0, 0, 38)
            FolderFrame.BackgroundColor3 = Theme.ElementBG
            FolderFrame.ClipsDescendants = true
            Instance.new("UICorner", FolderFrame).CornerRadius = UDim.new(0, 4)

            local FolderBtn = Instance.new("TextButton", FolderFrame)
            FolderBtn.Size = UDim2.new(1, 0, 0, 38)
            FolderBtn.BackgroundTransparency = 1
            FolderBtn.Text = ""

            local Label = Instance.new("TextLabel", FolderBtn)
            Label.Size = UDim2.new(1, -40, 1, 0)
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Theme.MainGreen
            Label.Font = Enum.Font.GothamMedium
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local Arrow = Instance.new("TextLabel", FolderBtn)
            Arrow.Size = UDim2.new(0, 20, 1, 0)
            Arrow.Position = UDim2.new(1, -30, 0, 0)
            Arrow.BackgroundTransparency = 1
            Arrow.Text = "▶"
            Arrow.TextColor3 = Theme.White
            Arrow.Font = Enum.Font.GothamBold
            Arrow.TextSize = 14

            local SubContent = Instance.new("Frame", FolderFrame)
            SubContent.Size = UDim2.new(1, -20, 1, -42)
            SubContent.Position = UDim2.new(0, 10, 0, 40)
            SubContent.BackgroundTransparency = 1
            local SubLayout = Instance.new("UIListLayout", SubContent)
            SubLayout.Padding = UDim.new(0, 6)

            local folderOpen = false
            local function UpdateFolderSize()
                if folderOpen then
                    local contentHeight = SubLayout.AbsoluteContentSize.Y
                    TweenService:Create(FolderFrame, TweenInfo.new(0.25), {Size = UDim2.new(1, 0, 0, 40 + contentHeight + 10)}):Play()
                    TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = 90}):Play()
                else
                    TweenService:Create(FolderFrame, TweenInfo.new(0.25), {Size = UDim2.new(1, 0, 0, 38)}):Play()
                    TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                end
            end

            FolderBtn.MouseButton1Click:Connect(function()
                folderOpen = not folderOpen
                UpdateFolderSize()
            end)
            SubLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if folderOpen then UpdateFolderSize() end
            end)

            return BuildElementsAPI(SubContent)
        end

        -- [แก้ไข] ถมสี Button เป็นสีเขียว 318F7D
        function Elements:CreateButton(text, callback)
            elementCount = elementCount + 1
            local Btn = Instance.new("TextButton", parentFrame)
            Btn.LayoutOrder = elementCount
            Btn.Size = UDim2.new(1, 0, 0, 36)
            Btn.BackgroundColor3 = Theme.MainGreen -- ถมสี 318F7D ตรงนี้เลย
            Btn.Text = ""
            Btn.AutoButtonColor = false
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

            local Label = Instance.new("TextLabel", Btn)
            Label.Size = UDim2.new(1, 0, 1, 0)
            Label.Position = UDim2.new(0, 0, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Theme.White
            Label.Font = Enum.Font.GothamBold -- ปุ่มทึบใช้ตัวหนาจะสวยครับ
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Center -- ให้อยู่กึ่งกลาง

            Btn.MouseButton1Click:Connect(function()
                -- อนิเมชันตอนกด เปลี่ยนเป็นเขียวเข้มขึ้นนิดนึง
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromHex("#246B5D")}):Play()
                task.wait(0.1)
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.MainGreen}):Play()
                if callback then callback() end
            end)
        end

        function Elements:CreateToggle(text, callback)
            elementCount = elementCount + 1
            local TogFrame = Instance.new("TextButton", parentFrame)
            TogFrame.LayoutOrder = elementCount
            TogFrame.Size = UDim2.new(1, 0, 0, 36)
            TogFrame.BackgroundColor3 = Theme.ElementBG
            TogFrame.Text = ""
            Instance.new("UICorner", TogFrame).CornerRadius = UDim.new(0, 4)

            local Label = Instance.new("TextLabel", TogFrame)
            Label.Size = UDim2.new(1, -70, 1, 0)
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Theme.MainGreen
            Label.Font = Enum.Font.GothamMedium
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local SwitchBG = Instance.new("Frame", TogFrame)
            SwitchBG.Size = UDim2.new(0, 36, 0, 18)
            SwitchBG.Position = UDim2.new(1, -50, 0.5, -9)
            SwitchBG.BackgroundColor3 = Theme.MainBG
            Instance.new("UICorner", SwitchBG).CornerRadius = UDim.new(1, 0)
            
            local SwitchStroke = Instance.new("UIStroke", SwitchBG)
            SwitchStroke.Color = Color3.fromHex("#555555")
            SwitchStroke.Thickness = 1
            SwitchStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

            local Circle = Instance.new("Frame", SwitchBG)
            Circle.Size = UDim2.new(0, 12, 0, 12)
            Circle.Position = UDim2.new(0, 3, 0.5, -6)
            Circle.BackgroundColor3 = Theme.White
            Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

            local state = false
            TogFrame.MouseButton1Click:Connect(function()
                state = not state
                if state then
                    TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -15, 0.5, -6)}):Play()
                    TweenService:Create(SwitchBG, TweenInfo.new(0.2), {BackgroundColor3 = Theme.MainGreen}):Play()
                    SwitchStroke.Color = Theme.MainGreen
                else
                    TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -6)}):Play()
                    TweenService:Create(SwitchBG, TweenInfo.new(0.2), {BackgroundColor3 = Theme.MainBG}):Play()
                    SwitchStroke.Color = Color3.fromHex("#555555")
                end
                if callback then callback(state) end
            end)
        end

        function Elements:CreateSlider(text, min, max, callback)
            elementCount = elementCount + 1
            local SliderFrame = Instance.new("Frame", parentFrame)
            SliderFrame.LayoutOrder = elementCount
            SliderFrame.Size = UDim2.new(1, 0, 0, 50)
            SliderFrame.BackgroundColor3 = Theme.ElementBG
            Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 4)

            local Label = Instance.new("TextLabel", SliderFrame)
            Label.Size = UDim2.new(1, -40, 0, 20)
            Label.Position = UDim2.new(0, 15, 0, 8)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Theme.MainGreen
            Label.Font = Enum.Font.GothamMedium
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local ValueLabel = Instance.new("TextLabel", SliderFrame)
            ValueLabel.Size = UDim2.new(0, 40, 0, 20)
            ValueLabel.Position = UDim2.new(1, -55, 0, 8)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(min)
            ValueLabel.TextColor3 = Theme.White
            ValueLabel.Font = Enum.Font.GothamMedium
            ValueLabel.TextSize = 12
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right

            local BarBG = Instance.new("Frame", SliderFrame)
            BarBG.Size = UDim2.new(1, -30, 0, 4)
            BarBG.Position = UDim2.new(0, 15, 0, 36)
            BarBG.BackgroundColor3 = Theme.MainBG
            Instance.new("UICorner", BarBG).CornerRadius = UDim.new(1, 0)
            
            local BarStroke = Instance.new("UIStroke", BarBG)
            BarStroke.Color = Color3.fromHex("#555555")
            BarStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

            local BarFill = Instance.new("Frame", BarBG)
            BarFill.Size = UDim2.new(0, 0, 1, 0)
            BarFill.BackgroundColor3 = Theme.MainGreen
            Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)

            local Knob = Instance.new("Frame", BarFill)
            Knob.Size = UDim2.new(0, 12, 0, 12)
            Knob.Position = UDim2.new(1, -6, 0.5, -6)
            Knob.BackgroundColor3 = Theme.White
            Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

            local Hitbox = Instance.new("TextButton", SliderFrame)
            Hitbox.Size = UDim2.new(1, 0, 1, 0)
            Hitbox.BackgroundTransparency = 1
            Hitbox.Text = ""

            local dragging = false
            local function updateSlider(input)
                local pos = math.clamp((input.Position.X - BarBG.AbsolutePosition.X) / BarBG.AbsoluteSize.X, 0, 1)
                BarFill.Size = UDim2.new(pos, 0, 1, 0)
                local value = math.floor(min + ((max - min) * pos))
                ValueLabel.Text = tostring(value)
                if callback then callback(value) end
            end

            Hitbox.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true; updateSlider(input)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then updateSlider(input) end
            end)
        end

        function Elements:CreateSelect(text, options, callback)
            elementCount = elementCount + 1
            local DropFrame = Instance.new("Frame", parentFrame)
            DropFrame.LayoutOrder = elementCount
            DropFrame.Size = UDim2.new(1, 0, 0, 38)
            DropFrame.BackgroundColor3 = Theme.ElementBG
            Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 4)

            local Label = Instance.new("TextLabel", DropFrame)
            Label.Size = UDim2.new(0.5, -15, 1, 0)
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Theme.MainGreen
            Label.Font = Enum.Font.GothamMedium
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local DropBtn = Instance.new("TextButton", DropFrame)
            DropBtn.AnchorPoint = Vector2.new(1, 0.5)
            DropBtn.Position = UDim2.new(1, -15, 0.5, 0)
            DropBtn.Size = UDim2.new(0, 100, 0, 24)
            DropBtn.AutomaticSize = Enum.AutomaticSize.X 
            DropBtn.BackgroundColor3 = Theme.MainBG
            DropBtn.Text = "select option    " 
            DropBtn.TextColor3 = Theme.White
            DropBtn.Font = Enum.Font.GothamMedium
            DropBtn.TextSize = 12
            DropBtn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", DropBtn).CornerRadius = UDim.new(0, 4)
            
            local MainStroke = Instance.new("UIStroke", DropBtn)
            MainStroke.Color = Theme.BoxStroke
            MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border 
            
            local Padding = Instance.new("UIPadding", DropBtn)
            Padding.PaddingLeft = UDim.new(0, 8)
            Padding.PaddingRight = UDim.new(0, 25)

            local Arrow = Instance.new("TextLabel", DropBtn)
            Arrow.AnchorPoint = Vector2.new(1, 0.5)
            Arrow.Position = UDim2.new(1, 20, 0.5, 0) 
            Arrow.Size = UDim2.new(0, 15, 1, 0)
            Arrow.BackgroundTransparency = 1
            Arrow.Text = "▼"
            Arrow.TextColor3 = Theme.White
            Arrow.Font = Enum.Font.Gotham
            Arrow.TextSize = 10

            -- [แก้ไข] นำ OptionList ไปไว้ที่ ScreenGui ชั้นนอกสุด ป้องกันการโดนตัดขอบจาก UIListLayout
            local OptionList = Instance.new("Frame", ScreenGui)
            OptionList.Name = "OptionList_Floating"
            
            local maxWidth = DropBtn.AbsoluteSize.X
            for _, opt in ipairs(options) do
                local textSize = TextService:GetTextSize(tostring(opt), 12, Enum.Font.GothamMedium, Vector2.new(1000, 26))
                if textSize.X + 30 > maxWidth then
                    maxWidth = textSize.X + 30
                end
            end
            
            OptionList.Size = UDim2.new(0, maxWidth, 0, 0)
            OptionList.AutomaticSize = Enum.AutomaticSize.Y
            OptionList.BackgroundColor3 = Color3.new(1,1,1)
            OptionList.Visible = false
            OptionList.ZIndex = 100
            Instance.new("UICorner", OptionList).CornerRadius = UDim.new(0, 4)
            
            local ListStroke = Instance.new("UIStroke", OptionList)
            ListStroke.Color = Theme.BoxStroke
            ListStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            
            local ListGradient = Instance.new("UIGradient", OptionList)
            ListGradient.Rotation = 90
            ListGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Theme.MainGreen),
                ColorSequenceKeypoint.new(1, Theme.DropdownGradient)
            })
            
            local OptLayout = Instance.new("UIListLayout", OptionList)
            OptLayout.Padding = UDim.new(0, 0)

            local dropOpen = false
            
            -- [แก้ไขสำคัญ] ตรวจจับว่าถ้าเลื่อนจอแล้วปุ่มโดนซ่อน (หรือหลุดกรอบ) ให้พับเก็บ Dropdown ทันที!
            RunService.RenderStepped:Connect(function()
                if dropOpen then
                    -- เช็คขอบเขตของหน้าต่าง TabPage
                    local tabY = parentFrame.AbsolutePosition.Y
                    local tabBottom = tabY + parentFrame.AbsoluteSize.Y
                    local btnY = DropBtn.AbsolutePosition.Y

                    -- ถ้าตัวปุ่ม Select หลุดขอบบน หรือหลุดขอบล่างไปแล้ว ให้ปิด Dropdown อัตโนมัติ
                    if btnY < tabY - 10 or btnY > tabBottom or not DropBtn.Visible or not DropFrame.Visible then
                        OptionList.Visible = false
                        dropOpen = false
                        Arrow.Text = "▼"
                        return
                    end

                    -- ให้ Dropdown วิ่งตามปุ่มเป๊ะๆ
                    OptionList.Position = UDim2.new(0, DropBtn.AbsolutePosition.X, 0, DropBtn.AbsolutePosition.Y + DropBtn.AbsoluteSize.Y + 2)
                    
                    if DropBtn.AbsoluteSize.X > maxWidth then
                        OptionList.Size = UDim2.new(0, DropBtn.AbsoluteSize.X, 0, 0)
                    end
                end
            end)

            DropBtn.MouseButton1Click:Connect(function()
                dropOpen = not dropOpen
                OptionList.Visible = dropOpen
                Arrow.Text = dropOpen and "▲" or "▼"
            end)

            for _, opt in ipairs(options) do
                local OptBtn = Instance.new("TextButton", OptionList)
                OptBtn.Size = UDim2.new(1, 0, 0, 26) 
                OptBtn.BackgroundTransparency = 1
                OptBtn.Text = tostring(opt)
                OptBtn.TextColor3 = Theme.White
                OptBtn.Font = Enum.Font.GothamMedium
                OptBtn.TextSize = 12
                OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                OptBtn.ZIndex = 101
                
                local OptPadding = Instance.new("UIPadding", OptBtn)
                OptPadding.PaddingLeft = UDim.new(0, 10)
                OptPadding.PaddingRight = UDim.new(0, 20)

                OptBtn.MouseButton1Click:Connect(function()
                    DropBtn.Text = tostring(opt) .. "    " 
                    dropOpen = false
                    OptionList.Visible = false
                    Arrow.Text = "▼"
                    if callback then callback(opt) end
                end)
            end
        end

        function Elements:CreateInput(text, callback)
            elementCount = elementCount + 1
            local InputFrame = Instance.new("Frame", parentFrame)
            InputFrame.LayoutOrder = elementCount
            InputFrame.Size = UDim2.new(1, 0, 0, 36)
            InputFrame.BackgroundColor3 = Theme.ElementBG
            Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0, 4)

            local Label = Instance.new("TextLabel", InputFrame)
            Label.Size = UDim2.new(0.5, -15, 1, 0)
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Theme.MainGreen
            Label.Font = Enum.Font.GothamMedium
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local TextBox = Instance.new("TextBox", InputFrame)
            TextBox.Size = UDim2.new(0.4, 0, 0, 24)
            TextBox.Position = UDim2.new(0.6, -15, 0.5, -12)
            TextBox.BackgroundColor3 = Theme.MainBG
            TextBox.Text = ""
            TextBox.PlaceholderText = "Type here..."
            TextBox.TextColor3 = Theme.White
            TextBox.Font = Enum.Font.GothamMedium
            TextBox.TextSize = 11
            Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 4)
            
            local InputStroke = Instance.new("UIStroke", TextBox)
            InputStroke.Color = Theme.BoxStroke
            InputStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

            TextBox.FocusLost:Connect(function()
                if callback then callback(TextBox.Text) end
            end)
        end

        function Elements:CreateKeybind(text, defaultKey, callback)
            elementCount = elementCount + 1
            local BindFrame = Instance.new("Frame", parentFrame)
            BindFrame.LayoutOrder = elementCount
            BindFrame.Size = UDim2.new(1, 0, 0, 36)
            BindFrame.BackgroundColor3 = Theme.ElementBG
            Instance.new("UICorner", BindFrame).CornerRadius = UDim.new(0, 4)

            local Label = Instance.new("TextLabel", BindFrame)
            Label.Size = UDim2.new(0.7, -15, 1, 0)
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Theme.MainGreen
            Label.Font = Enum.Font.GothamMedium
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local BindBtn = Instance.new("TextButton", BindFrame)
            BindBtn.Size = UDim2.new(0, 40, 0, 24)
            BindBtn.Position = UDim2.new(1, -55, 0.5, -12)
            BindBtn.BackgroundColor3 = Theme.MainBG
            BindBtn.Text = defaultKey.Name or ".."
            BindBtn.TextColor3 = Theme.White
            BindBtn.Font = Enum.Font.GothamMedium
            BindBtn.TextSize = 11
            Instance.new("UICorner", BindBtn).CornerRadius = UDim.new(0, 4)
            
            local BindStroke = Instance.new("UIStroke", BindBtn)
            BindStroke.Color = Theme.BoxStroke
            BindStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

            local key = defaultKey
            local waiting = false

            BindBtn.MouseButton1Click:Connect(function()
                BindBtn.Text = "..."
                waiting = true
            end)

            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if not gameProcessed then
                    if waiting and input.UserInputType == Enum.UserInputType.Keyboard then
                        key = input.KeyCode
                        BindBtn.Text = key.Name
                        waiting = false
                    elseif input.KeyCode == key and not waiting then
                        if callback then callback() end
                    end
                end
            end)
        end

        return Elements
    end

    function WindowInfo:CreateTab(tabName)
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(1, -10, 0, 32)
        TabBtn.BackgroundColor3 = Theme.TabInactiveBG
        TabBtn.Text = "      " .. tabName
        TabBtn.TextColor3 = Theme.White
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 13
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        local Indicator = Instance.new("Frame", TabBtn)
        Indicator.Size = UDim2.new(0, 4, 0.6, 0)
        Indicator.Position = UDim2.new(0, 6, 0.2, 0)
        Indicator.BackgroundColor3 = Theme.MainGreen
        Indicator.BorderSizePixel = 0
        Indicator.Visible = false
        Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

        local TabPage = Instance.new("ScrollingFrame", ContentContainer)
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.ScrollBarThickness = 2
        TabPage.ScrollBarImageColor3 = Theme.MainGreen
        TabPage.Visible = false
        TabPage.ClipsDescendants = true 
        TabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
        
        local PageLayout = Instance.new("UIListLayout", TabPage)
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        Instance.new("UIPadding", TabPage).PaddingRight = UDim.new(0, 10)

        table.insert(Tabs, {Btn = TabBtn, Page = TabPage, Ind = Indicator})

        TabBtn.MouseButton1Click:Connect(function()
            for _, tab in pairs(Tabs) do
                tab.Page.Visible = false
                TweenService:Create(tab.Btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.TabInactiveBG}):Play()
                tab.Btn.TextColor3 = Theme.White
                tab.Ind.Visible = false
            end
            TabPage.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.TabActiveBG}):Play()
            TabBtn.TextColor3 = Theme.MainGreen
            Indicator.Visible = true
            
            for _, child in pairs(ScreenGui:GetChildren()) do
                if child.Name == "OptionList_Floating" then
                    child.Visible = false
                end
            end
        end)

        if #Tabs == 1 then
            TabPage.Visible = true
            TabBtn.BackgroundColor3 = Theme.TabActiveBG
            TabBtn.TextColor3 = Theme.MainGreen
            Indicator.Visible = true
        end

        return BuildElementsAPI(TabPage)
    end

    return WindowInfo
end
