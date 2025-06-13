local allowedPlaceId = 1234567890

if game.PlaceId == allowedPlaceId then
	print("Script loading")
  wait(0.3)
  loadstring(game:HttpGet("https://pandadevelopment.net/virtual/file/352da89fd33d0143"))()
  
else
    -- Don't run anything, or optionally notify
    warn("Script not allowed in this game.")
end
