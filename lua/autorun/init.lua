if SERVER then
    AddCSLuaFile("menu.lua")
    AddCSLuaFile("animations.lua")
    AddCSLuaFile("autorun/init.lua")

    resource.AddFile("materials/fond.png")
    resource.AddFile("materials/gauche.png")
    resource.AddFile("materials/droite.png")
    resource.AddFile("materials/1.png")
    resource.AddFile("materials/2.png")
    resource.AddFile("materials/page.png")
    resource.AddFile("materials/fonts/KATANA.ttf")
    resource.AddFile("sound/changesound.mp3")
    resource.AddFile("sound/confirmsound.mp3")
else
    include("animations.lua")
    include("menu.lua")
end
