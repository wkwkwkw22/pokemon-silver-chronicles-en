#===============================================================================
# Whirlpool
#===============================================================================
def pbWhirlpool
  move = :WHIRLPOOL
  movefinder = $player.get_pokemon_with_move(move)
  if !pbCheckHiddenMoveBadge(Settings::BADGE_FOR_WHIRLPOOL, false) || (!$DEBUG && !movefinder)
    pbMessage(_INTL("It's a huge swirl of water."))
    return false
  end
  if pbConfirmMessage(_INTL("It's a huge swirl of water.\nWould you like to use Whirlpool?"))
    # $stats.whirlpool_count += 1
    speciesname = (movefinder) ? movefinder.name : $player.name
    pbMessage(_INTL("{1} used {2}!", speciesname, GameData::Move.get(move).name))
    pbHiddenMoveAnimation(movefinder)
    return true
  end
  return false
end

HiddenMoveHandlers::CanUseMove.add(:WHIRLPOOL, proc { |move, pkmn, showmsg|
  next false if !pbCheckHiddenMoveBadge(Settings::BADGE_FOR_WHIRLPOOL, showmsg)
  facingEvent = $game_player.pbFacingEvent
  if !facingEvent || !facingEvent.name[/whirlpooltree/i]
    pbMessage(_INTL("You can't use that here.")) if showmsg
    next false
  end
  next true
})

HiddenMoveHandlers::UseMove.add(:WHIRLPOOL, proc { |move, pokemon|
  if !pbHiddenMoveAnimation(pokemon)
    pbMessage(_INTL("{1} used {2}!", pokemon.name, GameData::Move.get(move).name))
  end
  # $stats.whirlpool_count += 1
  facingEvent = $game_player.pbFacingEvent
  if facingEvent
    pbEraseWhirlpoolEvent(facingEvent)
  end
  next true
})

def pbEraseWhirlpoolThisEvent
  event = get_self
  pbEraseWhirlpoolEvent(event) if event
  @index += 1
  return true
end

def pbEraseWhirlpoolEvent(event)
  return if !event
  if event.name[/redemoinho/i]
    pbSEPlay("Whirlpool", 80)
  end
  pbMoveRoute(event, [PBMoveRoute::Wait, 2,
                      PBMoveRoute::TurnLeft,
                      PBMoveRoute::Wait, 2,
                      PBMoveRoute::TurnRight,
                      PBMoveRoute::Wait, 2,
                      PBMoveRoute::TurnUp,
                      PBMoveRoute::Wait, 2])
  pbWait(Graphics.frame_rate * 4 / 10)
  event.erase
  $PokemonMap&.addErasedEvent(event.id)
end

