local menuOpen = false
local frame
local currentPage = 1
local animationsPerPage = 12
local totalPages = math.ceil(#animations / animationsPerPage)
local scaleFactor = 0.9 -- 1
local posX = 0.15 -- 0.5
local posY = 0.35 -- 0.5

surface.CreateFont("KatanaFont", {
    font = "KATANA",
    size = 24 * scaleFactor,
    weight = 500,
    antialias = true,
    shadow = true
})

surface.CreateFont("KatanaFontLarge", {
    font = "KATANA",
    size = 20 * scaleFactor,
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

    local frameWidth, frameHeight = 578 * scaleFactor, 728 * scaleFactor
    local bgWidth, bgHeight = 488 * scaleFactor, 728 * scaleFactor
    local btnWidth, btnHeight = 408 * scaleFactor, 33 * scaleFactor
    local arrowSize = 90 * scaleFactor
    local btnSpacing = 48 * scaleFactor

    frame = vgui.Create("DPanel")
    frame:SetSize(frameWidth, frameHeight)
    frame:SetPos(ScrW() * posX - frameWidth / 2, ScrH() * posY - frameHeight / 2)
    frame:SetVisible(true)
    frame:MakePopup()
    frame:SetPaintBackgroundEnabled(false)
    frame:SetDrawBackground(false)
    frame.Paint = function() end

    local background = vgui.Create("DImage", frame)
    background:SetPos(45 * scaleFactor, 0)
    background:SetSize(bgWidth, bgHeight)
    background:SetImage("fond.png")

    local leftArrow = vgui.Create("DImageButton", frame)
    leftArrow:SetPos(0, 319 * scaleFactor)
    leftArrow:SetSize(arrowSize, arrowSize)
    leftArrow:SetImage("gauche.png")
    leftArrow.DoClick = function()
        if currentPage > 1 then
            currentPage = currentPage - 1
            frame:Remove()
            drawMenu()
        end
    end
    
    local rightArrow = vgui.Create("DImageButton", frame)
    rightArrow:SetPos(488 * scaleFactor, 319 * scaleFactor)
    rightArrow:SetSize(arrowSize, arrowSize)
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
        btn:SetPos(85 * scaleFactor, 84 * scaleFactor + ((i - startIndex) * btnSpacing))
        btn:SetSize(btnWidth, btnHeight)
        btn:SetImage("1.png")
        
        local label = vgui.Create("DLabel", btn)
        label:SetSize(btnWidth, btnHeight)
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
            label:SetTextColor(Color(0, 0, 0))
        end
        btn.OnCursorExited = function()
            btn:SetImage("1.png")
            label:SetFont("KatanaFont")
            label:SetTextColor(Color(0, 0, 0))
        end
    end

    local pageIndicator = vgui.Create("DImage", frame)
    pageIndicator:SetPos((frameWidth - 125 * scaleFactor) / 2, 660 * scaleFactor)
    pageIndicator:SetSize(125 * scaleFactor, 39 * scaleFactor)
    pageIndicator:SetImage("page.png")

    local pageLabel = vgui.Create("DLabel", pageIndicator)
    pageLabel:SetSize(125 * scaleFactor, 39 * scaleFactor)
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
            currentPage = 1
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

concommand.Add("set_scale", function(ply, cmd, args)
    if args[1] then
        scaleFactor = tonumber(args[1]) / 100
        surface.CreateFont("KatanaFont", {
            font = "KATANA",
            size = 24 * scaleFactor,
            weight = 500,
            antialias = true,
            shadow = true
        })

        surface.CreateFont("KatanaFontLarge", {
            font = "KATANA",
            size = 20 * scaleFactor,
            weight = 500,
            antialias = true,
            shadow = true
        })

        if menuOpen then
            frame:Remove()
            drawMenu()
        end
    end
end)

concommand.Add("set_pos", function(ply, cmd, args)
    if args[1] and args[2] then
        posX = tonumber(args[1]) / 100
        posY = tonumber(args[2]) / 100

        if menuOpen then
            frame:Remove()
            drawMenu()
        end
    end
end)
