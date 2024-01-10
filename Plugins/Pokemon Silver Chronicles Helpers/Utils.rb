## Some helper functions that are used in the game



# MQS plugin helper function to know if quest is already active
# We can use this to avoid adding the same quest twice in cases where a quest
# can be activated in different places
# It checks if the quest was already completed or failed too!
# But I can't change the name of it, because I already used it in a lot of events!
def isQuestActive?(quest)
  $PokemonGlobal.quests.active_quests.each do |q|
    return true if q.id == quest
  end
  $PokemonGlobal.quests.completed_quests.each do |q|
    return true if q.id == quest
  end
  $PokemonGlobal.quests.failed_quests.each do |q|
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



def is_first_pokemon_species?(species, form = -1)
  pkmn = $player.party[0]
    if(pkmn.able? && pkmn.species == species && (form < 0 || pkmn.form == form))
      return true
    end  
  return false
end

 # Returns the correct index of the Pokemon in the party, or -1 if not found.
  def has_species_index?(species, form = -1)
    $player.party.each_with_index do |pkmn, index|
      if(pkmn.species == species && (form < 0 || pkmn.form == form))
        return index
      end  
    end
    return -1
  end

  #This is used to show Pokemon that NPCs want to see in quests
  # Returns 1 if the Pokemon is in the party and health
  # Returns 0 if has Pokemon, but is fainted
  # Return -1 if does not have Pokemon
  def switchPositionIfHasPokemon(species, form = -1)
    index = has_species_index?(species, form)
    if(index >= 0)
      return 0 if !$player.party[index].able?
      return 1 if index == 0 # Pokemon is already in the first position
      FollowingPkmn.toggle_off
      tmp = $player.party[0]
      $player.party[0] = $player.party[index]
      $player.party[index] = tmp
      FollowingPkmn.toggle_on
     
      return 1
    end
    return -1
  end   

