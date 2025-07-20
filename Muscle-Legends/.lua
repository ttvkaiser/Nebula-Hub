local allowedPlaceId = 3623096087

if game.PlaceId == allowedPlaceId then
	print("Script loading")
  wait(0.2)
  loadstring(game:HttpGet("https://pandadevelopment.net/virtual/file/9410453d82aa9e02"))()
  
else		
    warn("Game is not registered so it's not allowed in this game.")
end
