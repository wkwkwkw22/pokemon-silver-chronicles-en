module PhotographerSettings
  ANIMATION_COME_OUT = 542
end


class Game_Map
  def addPokemonOWToMapForPhotography(x,y,pokemon)
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
    # event.pages[0].move_type = VisibleEncounterSettings::DEFAULT_MOVEMENT[2]
    event.pages[0].step_anime = true if VisibleEncounterSettings::USE_STEP_ANIMATION
    event.pages[0].trigger = 0 # on action button
    # event.pages[0].move_route.list[0].code = 10
    # event.pages[0].move_route.list[1] = RPG::MoveCommand.new
    # for move in VisibleEncounterSettings::Enc_Movements do
    #   if pokemon.method(move[0]).call == move[1]
    #     event.pages[0].move_speed = move[2] if move[2]
    #     event.pages[0].move_frequency = move[3] if move[3]
    #     event.pages[0].move_type = move[4] if move[4]
    #   end
    # end
    # parameter = " pbDaycareInteract("+i.to_s+")"

    # Compiler::push_script(event.pages[0].list,sprintf(parameter))
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

    
    #--- show Pokéball animation --------------------------------------------------------
    spriteset = $scene.spriteset(@map_id)
    # anim_id = PhotographerSettings::ANIMATION_COME_OUT
    # spriteset&.addUserAnimation(PhotographerSettings::ANIMATION_COME_OUT, event.x, event.y, false, 1)
    pbMoveRoute($game_player, [PBMoveRoute::Wait, 2])
    pbWait(Graphics.frame_rate/5)
    return event
  end
end

# def pbDaycareInteract(i)
#   day_care = $PokemonGlobal.day_care
#   if (day_care[i].pokemon)
#     pokemon = day_care[i].pokemon
#     pbMessage(_INTL("{1} is training to become stronger.",pokemon.species))
#     GameData::Species.play_cry_from_species(pokemon.species,pokemon.form,90, 100)
#   end
# end

def pbPhotograph()
  # pbToneChangeAll(Tone.new(-255,-255,-255),0)
  # viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
  # viewport.z=99
  # bg=Sprite.new(viewport)
  # bg.bitmap=Bitmap.new("Graphics/Transitions/Black.png")
  
  # bg.opacity=0
  # Fade in
  # 20.times do
  #   bg.opacity+=13
  #   pbWait(1)
  # end
  # # Stay
  # bg.opacity=255
  # pbWait(60)
  # # Fade out
  # 20.times do
  #   bg.opacity-=13
  #   pbWait(1)
  # end
  # bg.dispose
  # viewport.dispose
  # pbWait(1)
  # pbToneChangeAll(Tone.new(0,0,0),0)

  pbToneChangeAll(Tone.new(-255,-255,-255),5)
  pbWait(10)

  FollowingPkmn.toggle(false,false)
  pbMoveRoute($game_player, [PBMoveRoute::TurnDown])

  xPosition = $game_player.x - 2
  yPosition = $game_player.y - 1
  events = []
  for i in 0...$player.party.length
    if(i < 3)
      xPosition = xPosition + 1
    elsif(i >= 3)
      if(i === 3)
        xPosition = $game_player.x - 2
        yPosition = yPosition - 1
      end
      xPosition = xPosition + 1
    end

    if(!$player.party[i].egg?)
      events.push($game_map.addPokemonOWToMapForPhotography(xPosition, yPosition, $player.party[i]))
    end
  end

  # ZOOM IN  
  # Just use this if you have the zoom plugin: https://reliccastle.com/resources/810/
  pbZoomMap(2,1,"in")
  # $game_map.scroll_up(10)
  pbScrollMap(8, 2, 5) # Move camera two tiles up

  # Game_Map.scroll_up(2)

  pbToneChangeAll(Tone.new(0,0,0),10)

  viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
  viewport.z=99
  bg=Sprite.new(viewport)
  bg.bitmap=Bitmap.new("Graphics/Pictures/Camera.png")
  pbWait(80)

  

  pbSEPlay("Camera Shutter Sound Effect") if FileTest.audio_exist?("Audio/SE/Camera Shutter Sound Effect")
  # TODO: Add a proper camera shutter animation that looks better than just a fadeout
  pbFadeOutIn()

  pbWait(80)

  bg.dispose
  viewport.dispose
  pbWait(5)

  t = pbGetTimeNow
  filestart = t.strftime("[%Y-%m-%d] %H_%M_%S.%L")
  capturefile = File.join("./Album/", (sprintf("%s.png", filestart)))
  Dir.mkdir("./Album") if !Dir.safe?("./Album")
  Graphics.screenshot(capturefile)

  pbToneChangeAll(Tone.new(-255,-255,-255),10)
  pbWait(20)
  pbDisposeZoomMap()
  pbMessage(_INTL("It has taken a picture successfully."))
  pbMessage(_INTL("Photo is saved on /Album folder."))

  pbScrollMap(2, 2, 5) # Go camera back two tiles down

  for event in events
    $game_map.events[event.id]&.erase
    $PokemonMap&.addErasedEvent(event.id)
  end

  pbToneChangeAll(Tone.new(0,0,0),10)
  

  FollowingPkmn.toggle(true,false)

end
  