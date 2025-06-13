local Games = loadstring(game:HttpGet("https://raw.githubusercontent.com/ttvkaiser/Nebula-Hub/refs/heads/main/Configuration/gamelist.lua"))()

for PlaceID, Execute in pairs(Games) do
    if PlaceID == game.PlaceId then
        loadstring(game:HttpGet(Execute))()
    end
end
