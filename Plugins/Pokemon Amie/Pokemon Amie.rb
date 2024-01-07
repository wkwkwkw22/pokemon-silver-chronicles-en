################################################################################
#                         Pokemon Amie/Refresh
#                           by BhagyaJyoti
#                        Adapted from PizzaSun
#                 Further Adapted from rigbycwts's script
#                         I adjusted a lot of things on this plugin myself - so I should never replace it!!
################################################################################
# use the following script to set Pokemon Amie a specific Pokemon
# beforehand:
# =============================================
# pokemonAmieRefresh(party index)
# =============================================
# to begin Pokemon Amie/Refresh Scene use:
# =========================================================
# pokemonAmieRefresh
# ==========================================================
#=========================================================#
# README
# You will need to fix a typo in 'def static?' in Easy Mouse System
# Change 'unless @static_x.eql?(@x) && @static_y.eql(@y)' to 'unless @static_x.eql?(@x) && @static_y.eql?(@y)'

################################################################################
# Pokemon-Amie/Pokemon Refresh Script
################################################################################

POKEMON_ZOOM = 3 # Zoom factor for Pokemon sprites
# All Things Pokemon can eat (Mostly Berries)
EATABLE_ITEMS = [
  :LAVACOOKIE,
  :OLDGATEAU,
  :CASTELIACONE,
  :RAGECANDYBAR,
  :SWEETHEART,
  :RARECANDY,
  :CHERIBERRY,
  :CHESTOBERRY,
  :PECHABERRY,
  :RAWSTBERRY,
  :ASPEARBERRY,
  :LEPPABERRY,
  :ORANBERRY,
  :PERSIMBERRY,
  :LUMBERRY,
  :SITRUSBERRY,
  :FIGYBERRY,
  :WIKIBERRY,
  :MAGOBERRY,
  :AGUAVBERRY,
  :IAPAPABERRY,
  :RAZZBERRY,
  :BLUKBERRY,
  :NANABBERRY,
  :WEPEARBERRY,
  :PINAPBERRY,
  :POMEGBERRY,
  :KELPSYBERRY,
  :QUALOTBERRY,
  :HONDEWBERRY,
  :GREPABERRY,
  :TAMATOBERRY,
  :CORNNBERRY,
  :MAGOSTBERRY,
  :RABUTABERRY,
  :NOMELBERRY,
  :SPELONBERRY,
  :PAMTREBERRY,
  :WATMELBERRY,
  :DURINBERRY,
  :BELUEBERRY,
  :OCCABERRY,
  :PASSHOBERRY,
  :WACANBERRY,
  :RINDOBERRY,
  :YACHEBERRY,
  :CHOPLEBERRY,
  :KEBIABERRY,
  :SHUCABERRY,
  :COBABERRY,
  :PAYAPABERRY,
  :TANGABERRY,
  :CHARTIBERRY,
  :KASIBBERRY,
  :HABANBERRY,
  :COLBURBERRY,
  :BABIRIBERRY,
  :CHILANBERRY,
  :LIECHIBERRY,
  :GANLONBERRY,
  :SALACBERRY,
  :PETAYABERRY,
  :APICOTBERRY,
  :LANSATBERRY,
  :STARFBERRY,
  :ENIGMABERRY,
  :MICLEBERRY,
  :CUSTAPBERRY,
  :JABOCABERRY,
  :ROWAPBERRY
]

class Pokemon
  attr_accessor :amie_affection # attr_accessor(:amie_affection)
  attr_accessor :amie_fullness # attr_accessor(:amie_fullness)
  attr_accessor :amie_enjoyment # attr_accessor(:amie_enjoyment) # Pokemon-Amie stats

  MAXAMIEPOINTS = 255 # Max points that a single Amie/Refresh stat can have
  @amie_affection = 0 if @amie_affection.nil?
  @amie_fullness = 0 if @amie_fullness.nil?
  @amie_enjoyment = 0 if @amie_enjoyment.nil?

  # Getters - return each stat values in points
  def amie_affection
    @amie_affection = 0 if @amie_affection.nil?
    return @amie_affection
  end

  def amie_fullness
    @amie_fullness = 0 if @amie_fullness.nil?
    return @amie_fullness
  end

  def amie_enjoyment
    @amie_enjoyment = 0 if @amie_enjoyment.nil?
    return @amie_enjoyment
  end

  # Setters - sets each stat values in points
  def amie_affection=(value)
    # Failsafes.
    if value > MAXAMIEPOINTS
      @amie_affection = MAXAMIEPOINTS
    elsif value < 0
      @amie_affection = 0
    else
      @amie_affection = value
    end
  end

  def amie_fullness=(value)
    # Failsafes.
    if value > MAXAMIEPOINTS
      @amie_fullness = MAXAMIEPOINTS
    elsif value < 0
      @amie_fullness = 0
    else
      @amie_fullness = value
    end
  end

  def amie_enjoyment=(value)
    # Failsafes.
    if value > MAXAMIEPOINTS
      @amie_enjoyment = MAXAMIEPOINTS
    elsif value < 0
      @amie_enjoyment = 0
    else
      @amie_enjoyment = value
    end
  end

  # Converts the points for every Amie stat into an abstracted level.
  def getAmieStatLevel(points)
    case points
    when 0
      return 0
    when 1...50
      return 1
    when 50...100
      return 2
    when 100...150
      return 3
    when 150...MAXAMIEPOINTS
      return 4
    when MAXAMIEPOINTS
      return 5
    end
  end

  # Returns the Affection level. Needed for other scripts, e.g. evolution methods
  def getAffectionLevel
    return getAmieStatLevel(amie_affection)
  end

  def getFullnessLevel
    return getAmieStatLevel(amie_fullness)
  end

  def getEnjoymentLevel
    return getAmieStatLevel(amie_enjoyment)
  end

  def feedAmie(food, pkmn, scene)
    return if amie_fullness >= MAXAMIEPOINTS
    return if getFullnessLevel == 5
    return unless EATABLE_ITEMS.include?(food)
    ItemHandlers.triggerUseOnPokemon(food, qty = 1, pkmn, scene) if pbCanUseOnPokemon?(food)
    if GameData::Item.get(food).is_berry?
      if !@berryPlantData
        pbRgssOpen("Data/berry_plants.dat", "rb") do |f|
          @berryPlantData = Marshal.load(f)
        end
      end
      if @berryPlantData && !@berryPlantData[GameData::Item.get(food)].nil?
        ber = @berryPlantData[GameData::Item.get(food)]
      else
        ber = [3, 15, 2, 5]
      end
      affGain = ber[0] + rand(4)
      fullGain = 90
      enjoyGain = 0
    else
      affGain = rand(3..6)
      fullGain = 90
      enjoyGain = 0
    end
    $bag.remove(GameData::Item.get(food).id)
    @amie_affection = amie_affection + affGain
    @amie_affection = [0, [amie_affection, MAXAMIEPOINTS].min].max
    @amie_fullness = amie_fullness + fullGain
    @amie_fullness = [0, [amie_fullness, MAXAMIEPOINTS].min].max
    @amie_enjoyment = amie_enjoyment + enjoyGain
    @amie_enjoyment = [0, [amie_enjoyment, MAXAMIEPOINTS].min].max
  end

  # Changes the happiness of this Pokémon depending on what happened to change it.
  def changeAmieStats(method)
    affGain = 0
    fullGain = 0
    enjoyGain = 0
    case method
    when "walking" # Walk approx. 50 steps
      fullGain = -1
      enjoyGain = -1
    when "sendInBattle" # Send Pokemon in to a battle
      fullGain = -25
      enjoyGain = -25
    when "feedPlainBean" # Feed Pokémon a whole Plain Bean
      affGain = 3
      fullGain = rand(100..101)
    when "feedPatternBean" # Feed Pokémon a whole Pattern Bean
      affGain = 5
      fullGain = rand(100..101)
    when "feedRainbowBean" # Feed Pokémon a whole Rainbow Bean
      affGain = 125
      fullGain = rand(100..101)
    when "feedMalasada" # Feed Pokemon a malasada (SunMoon) or a Shirogi bread (ColMerc)
      fullGain = 255
      affGain = 5
    when "feedMalasadaDisliked"
      fullGain = 255
      affGain = 3
    when "feedMalasadaLiked"
      fullGain = 255
      affGain = 10
    when "pet" # Pet Pokemon. No spots implemented due to engine limitations.
      affGain = rand(2..5)
      enjoyGain = rand(20..39)
    else
      pbMessage(_INTL("Unknown stat-changing method."))
    end
    @amie_affection = amie_affection + affGain
    @amie_affection = [0, [amie_affection, MAXAMIEPOINTS].min].max
    @amie_fullness = amie_fullness + fullGain
    @amie_fullness = [0, [amie_fullness, MAXAMIEPOINTS].min].max
    @amie_enjoyment = amie_enjoyment + enjoyGain
    @amie_enjoyment = [0, [amie_enjoyment, MAXAMIEPOINTS].min].max
  end

  # Sets the Pokemon's Affection to 0.
  # Usually used when traded.
  def resetAffection
    @amie_affection = 0
  end
end

# Gets Mouse X and Y positions
class Game_Mouse
  def x
    return @x
  end

  def y
    return @y
  end
end

# Gets First NonEgg Pokemon
def pbFirstNonEggPokemonOrFaintedPokemon
  for i in 0...$player.party.length
    p = $player.party[i]
    return $player.party[i] if p && !p.egg? && !p.fainted?
  end
  return nil
end

def pbClickSprite(sprite)
  i = 1
  5.times do
    sprite.zoom_x -= 0.1**i
    sprite.zoom_y -= 0.1**i
    i += 1
    Graphics.update
  end
  pbPlayCancelSE
  i = 1
  5.times do
    sprite.zoom_x += 0.1**i
    sprite.zoom_y += 0.1**i
    i += 1
    Graphics.update
  end
end

def setAmiePokemon(pkmn)
  if pkmn.nil?
    # if pkmn is not specified, get the first non-egg mon in the party
    ret = pbFirstNonEggPokemonOrFaintedPokemon
    return ret
  else
    # if pkmn is specified, make sure it's not an egg
    # if it's an egg, just get the first non-egg instead
    return $player.party[pkmn] unless $player.party[pkmn].egg?
    ret = pbFirstNonEggPokemonOrFaintedPokemon
    return ret

    # if pkmn is specified and it's not an egg, go with it!

  end
end # def setAmiePokemon(pkmn)

# Lowers Fullness and Enjoyment by 1 every 50 steps
HUNGERCOUNTER = 0
EventHandlers.add(:on_step_taken, :hungerCounter,
                  proc { |event|
                    HUNGERCOUNTER += 1
                    if HUNGERCOUNTER >= 50
                      for pkmn in $player.party
                        pkmn.changeAmieStats("walking")
                      end
                      HUNGERCOUNTER = 0
                    end
                  })

class PokeBattle_Battler
  attr_accessor :amie_affection
  attr_accessor :amie_fullness
  attr_accessor :amie_enjoyment

  # Getters - return each stat values in points
  def amie_affection
    return (@pokemon) ? @pokemon.amie_affection : 0
  end

  def amie_fullness
    return (@pokemon) ? @pokemon.amie_fullness : 0
  end

  def amie_enjoyment
    return (@pokemon) ? @pokemon.amie_enjoyment : 0
  end

  def getAffectionLevel
    return (@pokemon) ? @pokemon.getAmieStatLevel(@pokemon.amie_affection) : 0
  end
end

#===============================================================================
#  This class performs menu screen processing.
#-------------------------------------------------------------------------------
#  Adapted by rigbycwts for use with Pokemon-Amie for Essentials, Edited by Pizza Sun
#===============================================================================

class PokeAmie_Scene
  attr_accessor :animation_state

  #-----------------------------------------------------------------------------
  # * Frame Update
  #-----------------------------------------------------------------------------
  def updateWalkAnimation
    if @sprites["pokemon"].disposed?
      @animation_state = 0
      return
    end

    return if Mouse.over_pixel?(@sprites["pokemon"]) && Mouse.press?(@sprites["pokemon"], :left)

    # Calculate the new x-coordinate for the walking animation
    if @animation_state == 0
      # Store the initial y-coordinate of the sprite
      @initial_y = @sprites["pokemon"].y
    end

    if @animation_state < 100
      # Walk to the left
      @sprites["pokemon"].x -= 2
      @sprites["pokemon"] = create_mirrored_sprite(@sprites["pokemon"]) if animation_state == 99
    elsif @animation_state < 300
      # Walk to the right
      @sprites["pokemon"].x += 2
      # @sprites["pokemon"].mirror = true
      @sprites["pokemon"] = create_mirrored_sprite(@sprites["pokemon"]) if animation_state == 299
    else
      # Reset the walking state and mirror property
      @animation_state = -100
      # @sprites["pokemon"].mirror = false
      # @sprites["pokemon"] = create_mirrored_sprite(@sprites["pokemon"])

    end

    # Just move y a little bit to simulate a walking animation
    @sprites["pokemon"].y = @initial_y + (5 * Math.sin(@animation_state * Math::PI / 5))

    # Increment the animation state
    @animation_state += 1

    # Update the sprite and refresh the graphics
    pbUpdateSpriteHash(@sprites)
    Graphics.update
  end

  def update
    # Update windows
    pbUpdateSpriteHash(@sprites)
    updateWalkAnimation
    if @custom
      updateCustom
    else
      update_command
    end
    if switch == 1
      pbFadeOutIn(99_999) do
        pbSwitchScreen
      end
    end
    if switch != 0 && !@sprites["text"].nil? && !@sprites["text"].disposed?
      base = Color.new(248, 248, 248)
      shadow = Color.new(104, 104, 104)
      @selectedIndex = @partyIndex if @selectedIndex.nil?
      pkname = $player.party[@selectedIndex].name
      textpos1 = [
        [_INTL("Affection"), 32, 70, 0, base, shadow],
        [_INTL("Fullness"), 32, 102, 0, base, shadow],
        [_INTL("Enjoyment"), 32, 134, 0, base, shadow],
        [_INTL("Select the Pokémon you'd like to play with!"), 74, 348, 0, base, shadow],
        [pkname, 70, 20, 0, base, shadow]
      ]
      @sprites["text"].dispose
      @sprites["text"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
      pbSetSystemFont(@sprites["text"].bitmap)
      pbDrawTextPositions(@sprites["text"].bitmap, textpos1)
    end
    if @feedshow == 1
      if @sprites["feedshow"].nil?
        @sprites["feedshow"] = IconSprite.new(0, 0)
        @sprites["feedshow"].viewport = @viewport
        @sprites["feedshow"].setBitmap("Graphics/Pictures/Pokemon Amie/feedshow")
        @sprites["feedshow"].oy = @sprites["feedshow"].bitmap.height / 2
        @sprites["feedshow"].x = @sprites["feed"].x
        @sprites["feedshow"].y = @sprites["feed"].y
        sprite = @sprites["feedshow"]
        w = sprite.bitmap.width
        sprite.zoom_x = 0.2
        sprite.zoom_y = 0.2
        8.times do
          # if (sprite.x+(sprite.zoom_x+0.1)*w)>=512
          #  break
          # end
          sprite.zoom_x += 0.1
          Graphics.update
        end
        4.times do
          sprite.zoom_y += 0.2
          Graphics.update
        end
      elsif @sprites["feedshow"].disposed?
        @sprites["feedshow"] = IconSprite.new(0, 0)
        @sprites["feedshow"].viewport = @viewport
        @sprites["feedshow"].setBitmap("Graphics/Pictures/Pokemon Amie/feedshow")
        @sprites["feedshow"].oy = @sprites["feedshow"].bitmap.height / 2
        @sprites["feedshow"].x = @sprites["feed"].x
        @sprites["feedshow"].y = @sprites["feed"].y
        sprite = @sprites["feedshow"]
        w = sprite.bitmap.width
        sprite.zoom_x = 0.2
        sprite.zoom_y = 0.2
        8.times do
          # if (sprite.x+(sprite.zoom_x+0.1)*w)>=512
          #  break
          # end
          sprite.zoom_x += 0.1
          Graphics.update
        end
        4.times do
          sprite.zoom_y += 0.2
          Graphics.update
        end
      end
      @foodnum = 0
      @sprites["itemcount"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
      pbSetSystemFont(@sprites["itemcount"].bitmap)
      @sprites["itemcount"].bitmap.font.size = 24
      @sprites["itemcount"].z = 1
      for item in EATABLE_ITEMS
        next unless $bag.quantity(item) > 0
        @items[@foodnum] = item
        @sprites["food#{@foodnum}"] = ItemIconSprite.new(0, 0, nil, @viewport)
        @sprites["food#{@foodnum}"].item = GameData::Item.get(item).id
        @sprites["food#{@foodnum}"].ox = @sprites["food#{@foodnum}"].bitmap.width / 2
        @sprites["food#{@foodnum}"].oy = @sprites["food#{@foodnum}"].bitmap.height / 2
        @sprites["food#{@foodnum}"].x = @sprites["food#{@foodnum}"].ox + @sprites["feed"].ox + @sprites["feed"].x + (@sprites["food#{@foodnum}"].bitmap.width * @foodnum)
        @sprites["food#{@foodnum}"].y = @sprites["feed"].y
        num = $bag.quantity(item)
        pbDrawOutlineText(@sprites["itemcount"].bitmap, @sprites["food#{@foodnum}"].x, @sprites["food#{@foodnum}"].y, 24,
                          24, num.to_s, Color.new(248, 248, 248), Color.new(30, 30, 30), 0)
        srcx = @sprites["feed"].x - @sprites["food#{@foodnum}"].x
        srcx = 0 if srcx < 0
        @sprites["food#{@foodnum}"].src_rect.set(srcx, 0, @sprites["food#{@foodnum}"].bitmap.width,
                                                 @sprites["food#{@foodnum}"].bitmap.width)
        @foodnum += 1
      end
      @feedshow = 3
    elsif @feedshow == 2
      for item in 0...(@foodnum)
        @sprites["food#{item}"].dispose
        @sprites["itemcount"].dispose
      end
      sprite = @sprites["feedshow"]
      4.times do
        sprite.zoom_y -= 0.2
        Graphics.update
      end
      8.times do
        break if ((sprite.zoom_x - 0.1)) <= 0
        sprite.zoom_x -= 0.1
        Graphics.update
      end
      sprite.dispose
      @feedshow = 0
    end
    return
  end

  def switch
    return @switch
  end

  def pbSwitchScreen
    base   = Color.new(248, 248, 248)
    shadow = Color.new(104, 104, 104)
    pkname = $player.party[@partyIndex].name
    textpos1 = [
      [_INTL("Affection"), 32, 70, 0, base, shadow],
      [_INTL("Fullness"), 32, 102, 0, base, shadow],
      [_INTL("Enjoyment"), 32, 134, 0, base, shadow],
      [_INTL("Select the Pokémon you'd like to play with!"), 74, 348, 0, base, shadow],
      [pkname, 70, 20, 0, base, shadow]
    ]
    @sprites["text"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    pbSetSystemFont(@sprites["text"].bitmap)
    pbDrawTextPositions(@sprites["text"].bitmap, textpos1)
    for i in 0...($player.party.length)
      @sprites["pokeicon#{i}"] = PokemonIconSprite.new($player.party[i], @viewport)
      @sprites["pokeicon#{i}"].ox = @sprites["pokeicon#{i}"].bitmap.width / 4
      @sprites["pokeicon#{i}"].oy = @sprites["pokeicon#{i}"].bitmap.height / 2
      @sprites["pokeicon#{i}"].x = 68 + (76 * i)
      @sprites["pokeicon#{i}"].y = 228
      @sprites["pokeicon#{i}"].z = 1
    end
    index = @partyIndex + 1
    @sprites["bgmap"].setBitmap("Graphics/Pictures/Pokemon Amie/bgswitch" + index.to_s)
    @sprites["pokemon"].dispose
    @sprites["switch"].dispose
    @sprites["feed"].dispose
    if !@sprites["feedshow"].nil? && !@sprites["feedshow"].disposed?
      @sprites["feedshow"].dispose
      @feedshow = 0
    end
    if @foodnum > 0
      @sprites["itemcount"].dispose if !@sprites["itemcount"].nil? && !@sprites["itemcount"].disposed?
      for x in 0...@foodnum
        next if @sprites["food#{x}"].nil?
        @sprites["food#{x}"].dispose if !@sprites["food#{x}"].disposed?
      end
    end
    @sprites["active"] = IconSprite.new(0, 0)
    @sprites["active"].viewport = @viewport
    @sprites["active"].setBitmap("Graphics/Pictures/Pokemon Amie/active")
    @sprites["active"].ox = @sprites["active"].bitmap.width / 2
    @sprites["active"].oy = @sprites["active"].bitmap.height / 2
    @sprites["active"].x = 68 + (76 * @partyIndex) + 24
    @sprites["active"].y = 228 + 24
    @sprites["active"].z = 2
    # Draw Affection
    for a in 1...6
      @sprites["affect#{a}"] = IconSprite.new(0, 0)
      if a <= @pokemon.getAffectionLevel
        @sprites["affect#{a}"].setBitmap("Graphics/Pictures/Pokemon Amie/affect")
      else
        @sprites["affect#{a}"].setBitmap("Graphics/Pictures/Pokemon Amie/affect_empty")
      end
      space = 15
      @sprites["affect#{a}"].viewport = @viewport
      @sprites["affect#{a}"].ox = @sprites["affect#{a}"].bitmap.width / 2
      @sprites["affect#{a}"].oy = @sprites["affect#{a}"].bitmap.height / 2
      @sprites["affect#{a}"].x = 178 + (@sprites["affect#{a}"].bitmap.width * a) + space
      @sprites["affect#{a}"].y = 87
      # Draw Fullness
      @sprites["full#{a}"] = IconSprite.new(0, 0)
      if a <= @pokemon.getFullnessLevel
        @sprites["full#{a}"].setBitmap("Graphics/Pictures/Pokemon Amie/full")
      else
        @sprites["full#{a}"].setBitmap("Graphics/Pictures/Pokemon Amie/full_empty")
      end
      space = 15
      @sprites["full#{a}"].viewport = @viewport
      @sprites["full#{a}"].ox = @sprites["full#{a}"].bitmap.width / 2
      @sprites["full#{a}"].oy = @sprites["full#{a}"].bitmap.height / 2
      @sprites["full#{a}"].x = 178 + (@sprites["full#{a}"].bitmap.width * a) + space
      @sprites["full#{a}"].y = 87 + 32
      # Draw Enjoyment
      @sprites["enjoy#{a}"] = IconSprite.new(0, 0)
      if a <= @pokemon.getEnjoymentLevel
        @sprites["enjoy#{a}"].setBitmap("Graphics/Pictures/Pokemon Amie/enjoy")
      else
        @sprites["enjoy#{a}"].setBitmap("Graphics/Pictures/Pokemon Amie/enjoy_empty")
      end
      space = 15
      @sprites["enjoy#{a}"].viewport = @viewport
      @sprites["enjoy#{a}"].ox = @sprites["enjoy#{a}"].bitmap.width / 2
      @sprites["enjoy#{a}"].oy = @sprites["enjoy#{a}"].bitmap.height / 2
      @sprites["enjoy#{a}"].x = 178 + (@sprites["enjoy#{a}"].bitmap.width * a) + space
      @sprites["enjoy#{a}"].y = 87 + 64
    end
    @switch = 2
  end
  #-----------------------------------------------------------------------------

  def pbStartScene(pokemon)
    @pokemon = pokemon
    @partyIndex = getPartyIndex(@pokemon)
    @sprites = {}
    @counter = 0
    @foodcounter = 0
    @shouldbreak = false
    @time1 = 0
    @time2 = 0
    @time3 = 0
    @switch = 0
    @feedshow = 0
    @foodnum = 0
    @mouse_x = nil
    @food = nil
    @feeding = false
    @items = []
    @mask = nil
    @full = false
    #-----------------------------------------------------------------------------
    # * Main Processing
    #-----------------------------------------------------------------------------
    def main
      # Make command window
      fadein = true
      # Makes the text window
      @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
      @viewport.z = 99_999
      @sprites["bgmap"] = IconSprite.new(0, 0)
      @sprites["bgmap"].setBitmap("Graphics/Pictures/Pokemon Amie/" + pbBackdrop)
      @sprites["bgmap"].viewport = @viewport
      @sprites["mouse"] = IconSprite.new(0, 0)
      @sprites["mouse"].setBitmap("Graphics/Pictures/Pokemon Amie/hand2")
      @sprites["mouse"].z = 5
      @sprites["mouse"].viewport = @viewport
      @sprites["mouse"].ox = @sprites["mouse"].bitmap.width / 2
      @sprites["mouse"].oy = @sprites["mouse"].bitmap.height / 2
      @sprites["mouse"].x = Mouse.x if defined?(Mouse.x)
      @sprites["mouse"].y = Mouse.y if defined?(Mouse.y)

      @sprites["switch"] = IconSprite.new(0, 0)
      @sprites["switch"].setBitmap("Graphics/Pictures/Pokemon Amie/switch")
      @sprites["switch"].viewport = @viewport
      # sets switch icon to bottom right
      @sprites["switch"].ox = @sprites["switch"].bitmap.width
      @sprites["switch"].oy = @sprites["switch"].bitmap.height
      @sprites["switch"].x = Graphics.width # SCREEN_WIDTH
      @sprites["switch"].y = Graphics.height # SCREEN_HEIGHT
      @sprites["back"] = IconSprite.new(0, 0)
      @sprites["back"].setBitmap("Graphics/Pictures/Pokemon Amie/back")
      @sprites["back"].viewport = @viewport
      # sets 'back' icon to bottom left
      @sprites["back"].oy = @sprites["back"].bitmap.height
      @sprites["back"].y = Graphics.height # SCREEN_HEIGHT
      @sprites["feed"] = IconSprite.new(0, 0)
      @sprites["feed"].setBitmap("Graphics/Pictures/Pokemon Amie/feed")
      @sprites["feed"].viewport = @viewport
      # sets switch icon to bottom right
      @sprites["feed"].ox = @sprites["feed"].bitmap.width / 2
      @sprites["feed"].oy = @sprites["feed"].bitmap.height / 2
      @sprites["feed"].x = 50
      @sprites["feed"].y = 50
      @sprites["feed"].z = 2
      @sprites["pokemon"] = PokemonSprite.new(@viewport)
      @sprites["pokemon"].setPokemonBitmap(@pokemon)
      @sprites["pokemon"].mirror = false
      @sprites["pokemon"].color = Color.new(0, 0, 0, 0)
      @sprites["pokemon"].ox = @sprites["pokemon"].bitmap.width / 2
      @sprites["pokemon"].oy = @sprites["pokemon"].bitmap.height / 2
      @sprites["pokemon"].x = Graphics.width / 2 # SCREEN_WIDTH/2
      @sprites["pokemon"].y = (Graphics.height / 2) + 30 # SCREEN_HEIGHT/2+30
      @sprites["pokemon"].z = 3
      @pokemon.amie_enjoyment = (@pokemon.amie_enjoyment - 2)
      @sprites["pokemon"] = create_zoomed_sprite(@sprites["pokemon"]) if POKEMON_ZOOM != 1
      playPokemonInitialIteration
      @custom = false
    end

    # We can't just zoom the image, we need to create a new sprite with the correct size
    # otherwise the Mouse.over_pixel doesn't work as intended, as it still hover above the original image.
    def create_zoomed_sprite(original, zoom_factor = POKEMON_ZOOM)
      zoomed = Sprite.new
      zoomed.bitmap = Bitmap.new(original.bitmap.width * zoom_factor, original.bitmap.height * zoom_factor)
      # Corrected blt call
      zoomed.bitmap.stretch_blt(zoomed.bitmap.rect, original.bitmap, original.bitmap.rect)
      zoomed.x = original.x
      zoomed.y = original.y
      zoomed.z = 3
      zoomed.ox = zoomed.bitmap.width / 2
      zoomed.oy = zoomed.bitmap.height / 2
      zoomed.color = original.color
      zoomed.viewport = original.viewport
      original.dispose
      return zoomed
    end

    # We can't just use .mirror because the mouse.over_pixel?? method doesn't take into account the mirrored properties
    def create_mirrored_sprite(original)
      mirrored = Sprite.new
      mirrored.bitmap = Bitmap.new(original.bitmap.width, original.bitmap.height)
      # This seems quite heavy, there's probably a better way to do this
      for y in 0...original.bitmap.height
        for x in 0...original.bitmap.width
          mirrored.bitmap.set_pixel(original.bitmap.width - x - 1, y, original.bitmap.get_pixel(x, y))
        end
      end
      mirrored.x = original.x
      mirrored.y = original.y
      mirrored.z = 3
      mirrored.ox = mirrored.bitmap.width / 2
      mirrored.oy = mirrored.bitmap.height / 2
      mirrored.color = original.color
      mirrored.viewport = original.viewport
      original.dispose
      return mirrored
    end

    def playPokemonInitialIteration
      @pokemon.play_cry(90, 110)

      # Custom text example
      # pbDisplay(_INTL("{1} is looking at you!",@pokemon.name))
      return unless defined?(FollowingPkmn)
      # If we have FollowingPkmnEx, let's trigger the talk event
      random_val = rand(6)
      EventHandlers.trigger_2(:following_pkmn_talk, @pokemon, random_val, true)

      # Here we could do all sorts of logic
      # The commented code below is an example of an animation that looks like the Pokémon is excited
      # 15.times do
      #   # Rotate to the right
      #   5.times do
      #     @sprites["pokemon"].angle += 1
      #     pbUpdateSpriteHash(@sprites)
      #     Graphics.update
      #   end
      #   # Rotate to the left
      #   5.times do
      #     @sprites["pokemon"].angle -= 1
      #     pbUpdateSpriteHash(@sprites)
      #     Graphics.update
      #   end
      # end
    end

    def playHeartAnimation
      @pokemon.play_cry(90, 110)
      for i in 0...4 # creates the hearts
        @sprites["#{i}"] = IconSprite.new(0, 0)
        @sprites["#{i}"].setBitmap("Graphics/Pictures/Pokemon Amie/heart")
        @sprites["#{i}"].viewport = @viewport
        @sprites["#{i}"].z = 4
        @sprites["#{i}"].x = @sprites["pokemon"].x + rand(70) - 40 # SCREEN_WIDTH/2+rand(70)-40
        @sprites["#{i}"].y = (Graphics.height / 2) - rand(40) + 30 # SCREEN_HEIGHT/2-rand(40)+30
      end
      15.times do
        for i in 0...4 # moves hearts
          @sprites["#{i}"].x += (rand(100) / 10) - (rand(100) / 10)
          @sprites["#{i}"].y -= ((rand(4) / 3) + 1) * 3
        end
        pbUpdateSpriteHash(@sprites)
        Graphics.update
      end
      for i in 0...4
        @sprites["#{i}"].dispose
      end
    end

    def pbAmieMouse
      if !@sprites["pokemon"].disposed? && (@feeding != true)
        if Mouse.over_pixel?(@sprites["pokemon"]) && Mouse.press?(@sprites["pokemon"], :left) # Pressing mouse while over Pokemon?
          @sprites["mouse"].setBitmap("Graphics/Pictures/Pokemon Amie/hand1")
          pbWait(1)

          if !Mouse.static? # Is the mouse moving?
            @counter += 1
            if (Time.now.to_f - @time2.to_f) > (getPlayTime("Audio/SE/pet.ogg")) # Audio doesn't overlap
              pbSEPlay("pet.ogg", 90, 100)
              @time2 = Time.now

            end
            if @counter >= 50 # after counter reaches number, hearts appear
              @pokemon.changeAmieStats("pet")
              playHeartAnimation
              Graphics.update
              @counter = 0
            end
          end
        else
          @sprites["mouse"].setBitmap("Graphics/Pictures/Pokemon Amie/hand2")
        end
      end
      if !@sprites["pokemon"].disposed? && (@feeding == true)
        # holding food on the pokemon
        if Mouse.over_pixel?(@sprites["pokemon"]) && Mouse.press?(@sprites["pokemon"], :left) && !@food.nil?
          @nibbleCooldown += 1
          if @nibbleCooldown >= (Graphics.frame_rate * 1) / 2
            @foodcounter += 1
            @nibbleCooldown = 0
          end
          @time1 = Time.now
          if @foodcounter == 1
            pbSEPlay("eat.ogg", 90, 100)
            @mask = "Graphics/Pictures/Pokemon Amie/eaten1.png"
            @foodcounter = 2
          end
          if @foodcounter == 3
            pbSEPlay("eat.ogg", 90, 100)
            @mask = "Graphics/Pictures/Pokemon Amie/eaten2.png"
            @foodcounter = 4
          end
          if @foodcounter == 5
            pbSEPlay("eat.ogg", 90, 100)
            @sprites["mouse"].setBitmap("Graphics/Pictures/Pokemon Amie/eaten3.png")
            pk = @pokemon.species
            @pokemon.feedAmie(@food, @pokemon, self)
            @sprites["pokemon"].setPokemonBitmap(@pokemon) if pk != @pokemon.species
            @feeding = false
            @foodcounter = 0
            @time1 = 0
            playHeartAnimation
            @sprites["mouse"].setBitmap("Graphics/Pictures/Pokemon Amie/hand2")
            @sprites["mouse"].ox = @sprites["mouse"].bitmap.width / 2
            @sprites["mouse"].oy = @sprites["mouse"].bitmap.height / 2
            @mask = nil
            Graphics.update
          end
        else
          # not holding food on the pokemon
          @nibbleCooldown = 0
        end
        @sprites["mouse"].maskOLD(@mask)
      end
      # moves hand picture to mouse position
      @sprites["mouse"].x = Mouse.x if defined?(Mouse.x)
      @sprites["mouse"].y = Mouse.y if defined?(Mouse.y)
    end

    def pbBackdrop # gets background based off location
      environ = pbGetEnvironment
      # Choose backdrop
      backdrop = "Field"
      if environ == :Cave # PBEnvironment::Cave
        backdrop = "Cave"
      elsif environ == :MovingWater # PBEnvironment::MovingWater || environ==PBEnvironment::StillWater
        backdrop = "Water"
      elsif environ == :Underwater # PBEnvironment::Underwater
        backdrop = "Underwater"
      elsif environ == :Rock # PBEnvironment::Rock
        backdrop = "Mountain"
      elsif !$game_map || !$game_map.metadata
        backdrop = "IndoorA"
      end
      if $game_map
        back = $game_map.metadata.battle_background
        backdrop = back if back && back != ""
      end
      backdrop = $PokemonGlobal.nextBattleBack if $PokemonGlobal && $PokemonGlobal.nextBattleBack
      # Apply graphics
      battlebg = backdrop
      return battlebg
    end

    #-----------------------------------------------------------------------------
    # * Frame Update (when command window is active)
    #-----------------------------------------------------------------------------
    def updateCustom
      return unless Input.trigger?(Input::B)
      @custom = false
      return
    end

    def update_command
      # If B button was pressed
      if Input.trigger?(Input::BACK)
        if switch == 0
          pbPlayCancelSE
          @shouldbreak = true # ends scene loop and starts to end scene
        else
          pbPlayCancelSE
          @switch = 0
          pbFadeOutIn(99_999) do
            pbDisposeSpriteHash(@sprites)
            @viewport.dispose
            main
          end
        end
      end
      if !@sprites["textbox"].nil? && !@sprites["textbox"].disposed? && Mouse.click?(@sprites["textbox"])
        pbClickSprite(@sprites["textbox"])
        @switch = 0
        pbFadeOutIn(99_999) do
          @partyIndex = @selectedIndex
          @pokemon = $player.party[@partyIndex]
          pbDisposeSpriteHash(@sprites)
          @viewport.dispose
          main
        end
      end
      if !@sprites["switch"].disposed? && Mouse.click?(@sprites["switch"]) # clicks on switch sprite
        pbClickSprite(@sprites["switch"])
        @switch = 1
      end
      if !@sprites["feedshow"].nil? && !@sprites["feedshow"].disposed? && (Mouse.press?(@sprites["feedshow"],
                                                                                        :left) && !Mouse.over_pixel?(@sprites["feed"]) && Mouse.over_pixel?(@sprites["feedshow"])) && !@mouse_x.nil?
        dx = Mouse.x - @mouse_x
        dx = 0 if (@sprites["food#{@foodnum - 1}"].x + @sprites["food#{@foodnum - 1}"].bitmap.width + dx) <= 512
        lx = @sprites["food0"].ox + @sprites["feed"].ox + @sprites["feed"].x
        dx = 0 if (@sprites["food0"].x + dx) >= lx
        @sprites["itemcount"].bitmap.clear
        for x in 0...@foodnum
          @sprites["food#{x}"].x += dx
          srcx = @sprites["feed"].x - @sprites["food#{x}"].x + 40
          srcx = 0 if srcx < 0
          @sprites["food#{x}"].src_rect.set(srcx, 0, @sprites["food#{x}"].bitmap.width,
                                            @sprites["food#{x}"].bitmap.width)
          num = $bag.quantity(@items[x])
          if @sprites["feed"].x < @sprites["food#{x}"].x
            pbDrawOutlineText(@sprites["itemcount"].bitmap, @sprites["food#{x}"].x, @sprites["food#{x}"].y, 24, 24,
                              num.to_s, Color.new(248, 248, 248), Color.new(30, 30, 30), 0)
          end
        end
      end
      @mouse_x = Mouse.x
      if Input.release?(Input::MOUSELEFT) && (@feeding == true)
        @foodcounter = 0
        @mask = nil
        @feeding = false
      end
      if !@sprites["feedshow"].nil?
        @time1 = Time.now if Input.release?(Input::MOUSELEFT) || !Mouse.static?
        if Mouse.static? && ((Time.now.to_f - @time1.to_f) > 0.2) && !@sprites["feedshow"].disposed?
          for x in 0...@foodnum
            next unless Mouse.press?(@sprites["food#{x}"], :left)
            if @pokemon.getFullnessLevel == 5
              @full = true
              @time3 = Time.now
              pbDrawOutlineText(@sprites["itemcount"].bitmap, (Graphics.width / 2) - 64, @sprites["feed"].x + 30, 128, 32,
                                @pokemon.name + " is full!", Color.new(248, 248, 248), Color.new(30, 30, 30), 0)
              break
            end
            @sprites["mouse"].setBitmap(GameData::Item.icon_filename(@items[x]))
            @sprites["mouse"].ox = @sprites["mouse"].bitmap.width / 2
            @sprites["mouse"].oy = @sprites["mouse"].bitmap.height / 2
            @food = @items[x]
            @feeding = true
            @feedshow = 2
          end
        end
        if @full == true && ((Time.now.to_f - @time3.to_f) > 0.5)
          @full = false
          if !@sprites["feedshow"].nil? && !@sprites["feedshow"].disposed?
            @sprites["itemcount"].bitmap.clear
            for x in 0...@foodnum
              num = $bag.quantity(@items[x])
              pbDrawOutlineText(@sprites["itemcount"].bitmap, @sprites["food#{x}"].x, @sprites["food#{x}"].y, 24, 24,
                                num.to_s, Color.new(248, 248, 248), Color.new(30, 30, 30), 0)
            end
          end
        end
      end
      if !@sprites["feed"].disposed? && (Mouse.click?(@sprites["feed"]) && !Mouse.hold?(:left)) # clicks on feed sprite
        if @feedshow == 3
          pbClickSprite(@sprites["feed"])
          @feedshow = 2
        end
        if @feedshow == 0
          pbClickSprite(@sprites["feed"])
          @feedshow = 1
        end
      end
      if Mouse.click?(@sprites["back"])
        pbClickSprite(@sprites["back"])
        if switch == 0
          @shouldbreak = true # ends scene loop and starts to end scene
        else
          @switch = 0
          pbFadeOutIn(99_999) do
            pbDisposeSpriteHash(@sprites)
            @viewport.dispose
            main
          end
        end
      end
      for i in 0...($player.party.length)
        break if @sprites["pokeicon#{i}"].nil?
        break if @sprites["pokeicon#{i}"].disposed?

        # on the pokemon switch screen
        next unless Mouse.click?(@sprites["pokeicon#{i}"])
        @selectedIndex = i
        for a in 1...6
          if a <= $player.party[@selectedIndex].getAffectionLevel
            @sprites["affect#{a}"].setBitmap("Graphics/Pictures/Pokemon Amie/affect")
          else
            @sprites["affect#{a}"].setBitmap("Graphics/Pictures/Pokemon Amie/affect_empty")
          end
          space = 15
          @sprites["affect#{a}"].viewport = @viewport
          @sprites["affect#{a}"].ox = @sprites["affect#{a}"].bitmap.width / 2
          @sprites["affect#{a}"].oy = @sprites["affect#{a}"].bitmap.height / 2
          @sprites["affect#{a}"].x = 178 + (@sprites["affect#{a}"].bitmap.width * a) + space
          @sprites["affect#{a}"].y = 87
          # Draw Fullness
          if a <= ($player.party[@selectedIndex].getFullnessLevel)
            @sprites["full#{a}"].setBitmap("Graphics/Pictures/Pokemon Amie/full")
          else
            @sprites["full#{a}"].setBitmap("Graphics/Pictures/Pokemon Amie/full_empty")
          end
          space = 15
          @sprites["full#{a}"].viewport = @viewport
          @sprites["full#{a}"].ox = @sprites["full#{a}"].bitmap.width / 2
          @sprites["full#{a}"].oy = @sprites["full#{a}"].bitmap.height / 2
          @sprites["full#{a}"].x = 178 + (@sprites["full#{a}"].bitmap.width * a) + space
          @sprites["full#{a}"].y = 87 + 32
          # Draw Enjoyment
          if a <= ($player.party[@selectedIndex].getEnjoymentLevel)
            @sprites["enjoy#{a}"].setBitmap("Graphics/Pictures/Pokemon Amie/enjoy")
          else
            @sprites["enjoy#{a}"].setBitmap("Graphics/Pictures/Pokemon Amie/enjoy_empty")
          end
          space = 15
          @sprites["enjoy#{a}"].viewport = @viewport
          @sprites["enjoy#{a}"].ox = @sprites["enjoy#{a}"].bitmap.width / 2
          @sprites["enjoy#{a}"].oy = @sprites["enjoy#{a}"].bitmap.height / 2
          @sprites["enjoy#{a}"].x = 178 + (@sprites["enjoy#{a}"].bitmap.width * a) + space
          @sprites["enjoy#{a}"].y = 87 + 64
        end
        if $player.party[@selectedIndex].egg? && !@sprites["textbox"].nil? && !@sprites["textbox"].disposed?
          @sprites["textbox"].dispose
          @sprites["overlay"].dispose
        end
        if (@partyIndex != @selectedIndex) && !$player.party[@selectedIndex].egg? && (@sprites["textbox"].nil? or @sprites["textbox"].disposed?)
          @sprites["textbox"] = IconSprite.new(96, 281)
          @sprites["textbox"].setBitmap("Graphics/Pictures/Pokemon Amie/textbox")
          @sprites["textbox"].viewport = @viewport
          @sprites["textbox"].x += @sprites["textbox"].bitmap.width / 2
          @sprites["textbox"].y += @sprites["textbox"].bitmap.height / 2
          @sprites["textbox"].ox = @sprites["textbox"].bitmap.width / 2
          @sprites["textbox"].oy = @sprites["textbox"].bitmap.height / 2
          base   = Color.new(64, 64, 64)
          shadow = Color.new(176, 176, 176)
          tx = @sprites["textbox"].x
          ty = @sprites["textbox"].y - (3 * @sprites["textbox"].oy / 4)
          textpos = [
            [_INTL("Switch Pokémon!"), tx, ty, 2, base, shadow]
          ]
          @sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
          pbSetSystemFont(@sprites["overlay"].bitmap)
          pbDrawTextPositions(@sprites["overlay"].bitmap, textpos)
        end
        if @selectedIndex == @partyIndex && !@sprites["textbox"].nil? && !@sprites["textbox"].disposed?
          @sprites["textbox"].dispose
          @sprites["overlay"].dispose
        end

        index = i + 1
        @sprites["bgmap"].setBitmap("Graphics/Pictures/Pokemon Amie/bgswitch" + index.to_s)

      end
    end

    def break?
      return @shouldbreak
    end
    main
  end

  def getPartyIndex(pkmn)
    for i in 0...$player.party.length
      return i if $player.party[i] == pkmn
    end
  end # def getPartyIndex

  def pbEndScene
    # Disposes the windows
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
end

class PokeAmieScreen
  def initialize(scene)
    @scene = scene
    @animation_state = 0
    scene.animation_state = @animation_state
  end

  def pbStartAmie(pokemon)
    @scene.pbStartScene(pokemon)
    # Main loop
    loop do
      # Update game screen
      Graphics.update
      # Update input information
      Input.update
      # Frame update
      @scene.update
      # Mouse Check
      @scene.pbAmieMouse
      # Abort loop
      break if @scene.break?
    end
    pbFadeOutIn(99_999) do
      @scene.pbEndScene
    end
  end
end

def pokemonAmieRefresh(pkmn = nil)
  pokemon = setAmiePokemon(pkmn)
  pbFadeOutIn(99_999) do
    scene = PokeAmie_Scene.new
    screen = PokeAmieScreen.new(scene)
    screen.pbStartAmie(pokemon)
  end
end

def pbDisplay(text)
  intlText = _INTL("{1}", text)
  Console.echo_li("#{intlText}")
  # Opted for not showing "It won't have any effect." message, as it's annoying.
  return unless intlText != _INTL("It won't have any effect.")
  pbMessage(intlText)
end

# I choose to just ignore items that restore PP here for simplicity and because it would be too weird to first eat the berry,
# and then choose the move to restore PP for.
def pbChooseMove(pokemon, variableNumber)
  return -1
end

# These functions below are added to keep the 002_Item_Effects script to work properly
def pbUpdate; end

def pbRefresh; end

def pbHardRefresh; end

#------------------------------------------------------------------------------#

#=========================================================#
# P.S.
# The Sprite Mask script is required to run Pokemon Amie/Refresh and included
# Below. IF you already have it installed, you may remove it if you'd like.
#===============================================================================
# ** Sprite Mask
#        by Luka S.J.
#-------------------------------------------------------------------------------
# Allows you to use a bitmap, sprite or image path to a bitmap to use as a mask
# for a sprite's original bitmap.
#===============================================================================

# handled as an extension of the Sprite class
class Sprite
  # function used to to mask the Sprite's current bitmap with another
  def maskOLD(mask = nil, xpush = 0, ypush = 0)
    # exits out of the function if the sprite currently has no bitmap to mask
    return false if !bitmap
    # backs up the Sprites current bitmap
    bitmap = self.bitmap.clone
    # check for mask types
    if mask.is_a?(Bitmap) # accepts Bitmap.new
      mbmp = mask
    elsif mask.is_a?(Sprite) # accepts other Sprite.new
      mbmp = mask.bitmap
    elsif mask.is_a?(String) # accepts Strings
      mbmp = RPG::Cache.load_bitmap("", mask) # BitmapCache.load_bitmap(mask)
    else # exits if non-matching type
      return false
    end
    # creates a new bitmap
    self.bitmap = Bitmap.new(mbmp.width, mbmp.height)
    # creates the main mask
    mask = mbmp.clone
    # calculates the dimension metrics for pixel transfer
    ox = (bitmap.width - mbmp.width) / 2
    oy = (bitmap.height - mbmp.height) / 2
    width = mbmp.width + ox
    height = mbmp.height + oy
    # draws pixels to mask bitmap
    for y in oy...height
      for x in ox...width
        # gets pixel of mask for analysis
        pixel = mask.get_pixel(x - ox, y - oy)
        # gets pixel of current bitmap for analysis
        color = bitmap.get_pixel(x - xpush, y - ypush)
        # sets the new alpha to use the value of the mask alpha
        alpha = pixel.alpha
        alpha = color.alpha if color.alpha < pixel.alpha
        # draws new pixels onto the Sprite's bitmap
        self.bitmap.set_pixel(x - ox, y - oy, Color.new(color.red, color.green, color.blue, alpha))
      end
    end
    # returns finalized bitmap to be used elsewhere
    return self.bitmap
  end
end
