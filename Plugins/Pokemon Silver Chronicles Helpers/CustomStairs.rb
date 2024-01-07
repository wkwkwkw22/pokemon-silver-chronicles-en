
# Just this plugin is not enough for 100% good stairs, 
# some events have to be created for it to properly work
# Check Ruins Of Alph maps for a complete example 

# TODO: Change character graphics when going up/down stairs
# TODO: Improve how the following Pokémon appears/disappears
module CustomStairs

  STAIRCASE_UP_FROM_BEHIND = 965
  STAIRCASE_DOWN_ANIMATION_ACTIVE = 966

  DIRECTION_DOWN = 2 # This is the direction code RPG Maker uses
  DIRECTION_UP = 8 # This is the direction code RPG Maker uses
  ANIMATION_SPEED = 2

  def self.transferUp(map, x, y)
    # This event just activates if the user is facing up or down
    return if $game_player.direction != DIRECTION_DOWN && $game_player.direction != DIRECTION_UP
    # Although this pokemon movement seems unnecessary, it actually
    # fixes a glitch where the Pokemon jumps weirdly behind the playes when moving
    # backwards and the Pokemon is on left or right.
    FollowingPkmn.move_route([PBMoveRoute::Wait, Graphics.frame_rate])

    if $game_player.direction == DIRECTION_DOWN
      $game_switches[STAIRCASE_UP_FROM_BEHIND] = true
      pbMoveRoute($game_player,
                  [PBMoveRoute::ThroughOn,
                  PBMoveRoute::ChangeSpeed, ANIMATION_SPEED,
                  PBMoveRoute::ChangeFreq, ANIMATION_SPEED,
                  PBMoveRoute::Backward])
      pbWait(Graphics.frame_rate/ANIMATION_SPEED)
    else
      pbMoveRoute($game_player,
                  [PBMoveRoute::ThroughOn,
                  PBMoveRoute::AlwaysOnTopOn,
                  PBMoveRoute::ChangeSpeed, ANIMATION_SPEED,
                  PBMoveRoute::ChangeFreq, ANIMATION_SPEED,
                  PBMoveRoute::Up,
                  PBMoveRoute::Up])

      pbWait((Graphics.frame_rate * 2)/ANIMATION_SPEED)
    end

    $game_switches[STAIRCASE_UP_FROM_BEHIND] = false
    $game_switches[STAIRCASE_DOWN_ANIMATION_ACTIVE] = true

    pbSEPlay("Exit Door")

    pbMoveRoute($game_player,
                [PBMoveRoute::ThroughOff,
                PBMoveRoute::AlwaysOnTopOff])


    FollowingPkmn.toggle_off(false)
    transferPlayer(map, x, y, DIRECTION_UP)

    pbMoveRoute($game_player,
                [
                  PBMoveRoute::ChangeSpeed, ANIMATION_SPEED,
                  PBMoveRoute::ChangeFreq, ANIMATION_SPEED,
                  PBMoveRoute::Up,
                  PBMoveRoute::ChangeSpeed, 3,
                  PBMoveRoute::ChangeFreq, 3,
                  PBMoveRoute::Up
                ])

    pbWait(Graphics.frame_rate)
    FollowingPkmn.toggle_on(false)
    $game_switches[STAIRCASE_DOWN_ANIMATION_ACTIVE] = false
    $game_map.refresh
  end



  def self.transferDown(map, x, y)
    # This event just activates if the user is facing up or down
    return if $game_player.direction != DIRECTION_DOWN && $game_player.direction != DIRECTION_UP
    # Although this pokemon movement seems unnecessary, it actually
    # fixes a glitch where the Pokemon jumps weirdly behind the playes when moving
    # backwards and the Pokemon is on left or right.
    FollowingPkmn.move_route([PBMoveRoute::Wait, Graphics.frame_rate])
    $game_switches[STAIRCASE_DOWN_ANIMATION_ACTIVE] = true
    $game_map.refresh

    pbMoveRoute($game_player,
                [PBMoveRoute::TurnUp,
                PBMoveRoute::ChangeSpeed, ANIMATION_SPEED,
                PBMoveRoute::ChangeFreq, ANIMATION_SPEED,
                PBMoveRoute::Backward,
                PBMoveRoute::ThroughOn])

    pbWait(Graphics.frame_rate/ANIMATION_SPEED)
    

    $game_switches[STAIRCASE_UP_FROM_BEHIND] = false

    pbSEPlay("Exit Door")

    pbMoveRoute($game_player,
                [PBMoveRoute::ThroughOff,
                PBMoveRoute::AlwaysOnTopOn])


    transferPlayer(map, x, y, DIRECTION_UP)

    FollowingPkmn.toggle_off(false)

    # Still going down stairs after map transfer
    pbMoveRoute($game_player,
                [
                  PBMoveRoute::TurnUp,
                  PBMoveRoute::ChangeSpeed, ANIMATION_SPEED,
                  PBMoveRoute::ChangeFreq, ANIMATION_SPEED,
                  PBMoveRoute::Backward,
                  PBMoveRoute::ChangeSpeed, 3,
                  PBMoveRoute::ChangeFreq, 3,
                  PBMoveRoute::Down,
                  PBMoveRoute::AlwaysOnTopOff
                ])

    pbWait(Graphics.frame_rate)
    FollowingPkmn.toggle_on(false)
    FollowingPkmn.move_route([PBMoveRoute::Down])


    $game_switches[STAIRCASE_DOWN_ANIMATION_ACTIVE] = false

  end
end

