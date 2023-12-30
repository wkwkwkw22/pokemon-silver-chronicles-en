module VisibleDayCarOWSettings
  DAY_CARE_OW_MAP = 53
end


class Game_Map
  def addPokemonOWToMap(i, x,y,pokemon)
    if($game_map.map_id == VisibleDayCarOWSettings::DAY_CARE_OW_MAP) 
    event = RPG::Event.new(x,y)
    #--- nessassary properties ----------------------------------------
    key_id = (@events.keys.max || -1) + 1
    event.id = key_id
    event.x = x
    event.y = y
    #--- Graphic of the event -----------------------------------------
    encounter = [pokemon.species,pokemon.level]
    form = pokemon.form
    gender = pokemon.gender
    shiny = pokemon.shiny?
    #event.pages[0].graphic.tile_id = 0
    graphic_form = (VisibleEncounterSettings::SPRITES[0] && form!=nil) ? form : 0
    graphic_gender = (VisibleEncounterSettings::SPRITES[1] && gender!=nil) ? gender : 0
    graphic_shiny = (VisibleEncounterSettings::SPRITES[2] && shiny!=nil) ? shiny : false
    fname = ow_sprite_filename(encounter[0].to_s, graphic_form, graphic_gender, graphic_shiny)
    fname.gsub!("Graphics/Characters/","")

    event.pages[0].graphic.character_name = fname
    #--- movement of the event --------------------------------
    event.pages[0].move_speed = VisibleEncounterSettings::DEFAULT_MOVEMENT[0]
    event.pages[0].move_frequency = VisibleEncounterSettings::DEFAULT_MOVEMENT[1]
    event.pages[0].move_type = VisibleEncounterSettings::DEFAULT_MOVEMENT[2]
    event.pages[0].step_anime = true if VisibleEncounterSettings::USE_STEP_ANIMATION
    event.pages[0].trigger = 0 # on action button
    event.pages[0].move_route.list[0].code = 10
    event.pages[0].move_route.list[1] = RPG::MoveCommand.new
    for move in VisibleEncounterSettings::Enc_Movements do
      if pokemon.method(move[0]).call == move[1]
        event.pages[0].move_speed = move[2] if move[2]
        event.pages[0].move_frequency = move[3] if move[3]
        event.pages[0].move_type = move[4] if move[4]
      end
    end
    parameter = " pbDaycareInteract("+i.to_s+")"

    Compiler::push_script(event.pages[0].list,sprintf(parameter))
    Compiler::push_end(event.pages[0].list)
    #--- creating the event ------------------------------------------
    gameEvent = Game_Event.new(@map_id, event, self)
    gameEvent.id = key_id
    gameEvent.moveto(x,y)
  
    @events[key_id] = gameEvent
    #--- updating the sprites --------------------------------------------------------
    sprite = Sprite_Character.new(Spriteset_Map.viewport,@events[key_id])
    $scene.spritesets[self.map_id]=Spriteset_Map.new(self) if $scene.spritesets[self.map_id]==nil
    $scene.spritesets[self.map_id].character_sprites.push(sprite)
    end
  end
end

def pbDaycareInteract(i)
  day_care = $PokemonGlobal.day_care
  if (day_care[i].pokemon)
    pokemon = day_care[i].pokemon
    pbMessage(_INTL("{1} is training to become stronger.",pokemon.species))
    GameData::Species.play_cry_from_species(pokemon.species,pokemon.form,90, 100)
  end
end

def pbDayCareShowPokemonOW()
  day_care = $PokemonGlobal.day_care

  # TODO: improve this to use a for loop on day_care
  if (day_care[0].pokemon)
    if (day_care[0].pokemon.hasType?(:WATER))
      $game_map.addPokemonOWToMap(0, 47,19, day_care[0].pokemon)
    else
      $game_map.addPokemonOWToMap(0, 43,17, day_care[0].pokemon)
    end
  end

  if (day_care[1].pokemon)
    if (day_care[1].pokemon.hasType?(:WATER))
      $game_map.addPokemonOWToMap(1, 46,20, day_care[1].pokemon)
    else
      $game_map.addPokemonOWToMap(1, 45,17, day_care[1].pokemon)
    end  
  end
end
  