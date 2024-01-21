# Adds custom items effects to the the game.

ItemHandlers::UseFromBag.add(:UNOWNREPORT,proc { |item|
  $scene = Scene_Unownreport.new
   next 2
})

ItemHandlers::UseInField.add(:UNOWNREPORT,proc { |item|
   $scene = Scene_Unownreport.new
   next 2
})