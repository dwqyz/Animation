local menuOpen = false
local frame
local currentPage = 1
local animationsPerPage = 12
local totalPages = math.ceil(#animations / animationsPerPage)

surface.CreateFont("KatanaFont", {
    font = "KATANA",
    size = 24,
    weight = 500,
    antialias = true,
    shadow = true
})

surface.CreateFont("KatanaFontLarge", {
    font = "KATANA",
    size = 20,
    weight = 500,
    antialias = true,
    shadow = true
})

local function playSound(soundPath)
    surface.PlaySound(soundPath)
end

local function playAnimation(sequence)
    local player = LocalPlayer()
    if player then
        local seq = player:LookupSequence(sequence)
        if seq and seq > 0 then
            player:SetSequence(seq)
            player:ResetSequence(seq)
            player:SetCycle(0)
            player:SetPlaybackRate(1)
            print("Playing sequence: " .. sequence)
        else
            print("Sequence not found: " .. sequence)
        end
    else
        print("Player not found.")
    end
end

local function drawMenu()
    if not menuOpen then return end

    frame = vgui.Create("DPanel")
    frame:SetSize(578, 728)
    frame:Center()
    frame:SetVisible(true)
    frame:MakePopup()
    frame:SetPaintBackgroundEnabled(false)
    frame:SetDrawBackground(false)
    frame.Paint = function() end

    local background = vgui.Create("DImage", frame)
    background:SetPos(45, 0)
    background:SetSize(488, 728)
    background:SetImage("fond.png")

    local leftArrow = vgui.Create("DImageButton", frame)
    leftArrow:SetPos(0, 319)
    leftArrow:SetSize(90, 90)
    leftArrow:SetImage("gauche.png")
    leftArrow.DoClick = function()
        if currentPage > 1 then
            currentPage = currentPage - 1
            frame:Remove()
            drawMenu()
        end
    end
    
    local rightArrow = vgui.Create("DImageButton", frame)
    rightArrow:SetPos(488, 319)
    rightArrow:SetSize(90, 90)
    rightArrow:SetImage("droite.png")
    rightArrow.DoClick = function()
        if currentPage < totalPages then
            currentPage = currentPage + 1
            frame:Remove()
            drawMenu()
        end
    end

    local startIndex = (currentPage - 1) * animationsPerPage + 1
    local endIndex = math.min(currentPage * animationsPerPage, #animations)

    for i = startIndex, endIndex do
        local btn = vgui.Create("DImageButton", frame)
        btn:SetPos(85, 84 + ((i - startIndex) * 48))
        btn:SetSize(408, 33)
        btn:SetImage("1.png")
        
        local label = vgui.Create("DLabel", btn)
        label:SetSize(408, 33)
        label:SetContentAlignment(5)
        label:SetFont("KatanaFont")
        label:SetTextColor(Color(0, 0, 0))
        label:SetText(animations[i].Name)
        
        btn.DoClick = function()
            playSound("confirmsound.mp3")
            playAnimation(animations[i].Sequence)
        end
        btn.OnCursorEntered = function()
            playSound("changesound.mp3")
            btn:SetImage("2.png")
            label:SetFont("KatanaFontLarge")
            label:SetTextColor(Color(0, 0, 0)) -- Change text color to black
        end
        btn.OnCursorExited = function()
            btn:SetImage("1.png")
            label:SetFont("KatanaFont")
            label:SetTextColor(Color(0, 0, 0)) -- Change text color back to black
        end
    end

    local pageIndicator = vgui.Create("DImage", frame)
    pageIndicator:SetPos((578 - 125) / 2, 660)
    pageIndicator:SetSize(125, 39)
    pageIndicator:SetImage("page.png")

    local pageLabel = vgui.Create("DLabel", pageIndicator)
    pageLabel:SetSize(125, 39)
    pageLabel:SetContentAlignment(5)
    pageLabel:SetFont("KatanaFont")
    pageLabel:SetTextColor(Color(255, 255, 255))
    pageLabel:SetText(currentPage .. "/" .. totalPages)
    pageLabel:Center()
end

hook.Add("Think", "CheckF7", function()
    if input.IsKeyDown(KEY_F7) then
        if not menuOpen then
            menuOpen = true
            currentPage = 1 -- Reset to page 1 when the menu is opened
            drawMenu()
        end
    else
        if menuOpen then
            menuOpen = false
            if IsValid(frame) then
                frame:Remove()
            end
        end
    end
end)
