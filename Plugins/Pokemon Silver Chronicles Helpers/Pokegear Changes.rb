
#===============================================================================
# Deluxe Settings.
#===============================================================================
module PokegearSettings 
    MISSIONS_ON_SWITCH = 963
    DEXNAV_ON_SWITCH = 964
end

MenuHandlers.add(:pokegear_menu, :missions, {
  "name"      => _INTL("Tasks"),
  "icon_name" => "missions",
  "order"     => 40,
  "condition" => proc { next $game_switches[PokegearSettings::MISSIONS_ON_SWITCH] == true},
  "effect"    => proc { |menu|
    pbFadeOutIn {
      scene = QuestList_Scene.new
      screen = QuestList_Screen.new(scene)
      screen.pbStartScreen
    }
    next false
  }
})

MenuHandlers.add(:pokegear_menu, :dexnav, {
  "name"      => _INTL("DexNav"),
  "icon_name" => "dexnav",
  "order"     => 50,
  "condition" => proc { next $game_switches[PokegearSettings::DEXNAV_ON_SWITCH] == true},
  "effect"    => proc { |menu|
    pbFadeOutIn {
      scene = EncounterList_Scene.new
      screen = EncounterList_Screen.new(scene)
      screen.pbStartScreen
    }
    next false
  }
})