# Adds custom items effects to the the game.
ItemHandlers::UseInField.add(:TCGBINDER,proc { |item|
   # scene = TripleTriadBinder_Scene.new
   # $screen = TripleTriadBinderScreen.new(scene)
   # $screen.pbStartScreen()
   pbTriadBinder()
   next 2
})
