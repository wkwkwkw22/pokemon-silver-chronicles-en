## Some helper functions that are used in the game



# MQS plugin helper function to know if quest is already active
# We can use this to avoid adding the same quest twice in cases where a quest
# can be activated in different places
def isQuestActive?(quest)
  $PokemonGlobal.quests.active_quests.each do |q|
    return true if q.id == quest
  end
  return false
end

# Could not find a generic transfer player function on Essentials,
# so I made this one.
def transferPlayer(map, x, y, direction = 0)
  pbFadeOutIn do
    $game_temp.player_transferring  = true
    $game_temp.player_new_map_id    = map
    $game_temp.player_new_x         = x
    $game_temp.player_new_y         = y
    $game_temp.player_new_direction = direction
    pbDismountBike
    $scene.transfer_player
    # $game_map.refresh
    $game_map.need_refresh = true   # in case player moves to the same map
  end
end

