#==========================
# Triple Triad changes made by victordevjs
#==========================
class TriadCard

  def self.createImprovedBack(type = nil, noback = false)
    bitmap = BitmapWrapper.new(80, 96)
    if !noback
      cardbitmap = AnimatedBitmap.new("Graphics/Pictures/Triple Triad/triad_card_back")
      bitmap.blt(0, 0, cardbitmap.bitmap, Rect.new(0, 0, cardbitmap.width, cardbitmap.height))
      cardbitmap.dispose
    end
    if type
      typebitmap = AnimatedBitmap.new(_INTL("Graphics/Pictures/types"))
      type_number = GameData::Type.get(type).icon_position
      typerect = Rect.new(0, type_number * 28, 64, 28)
      bitmap.blt(8, 50, typebitmap.bitmap, typerect, 192)
      typebitmap.dispose
    end
    return bitmap
  end

  def createModifiedBitmap(owner)
    return TriadCard.createImprovedBack if owner == 0
    bitmap = BitmapWrapper.new(80, 96)
    if owner == 2   # Opponent
      cardbitmap = AnimatedBitmap.new("Graphics/Pictures/Triple Triad/triad_card_back")
    else            # Player
      cardbitmap = AnimatedBitmap.new("Graphics/Pictures/Triple Triad/types/card_#{@type}")
    end
    filename = @form > 0 ? "#{@species}_#{@form}" : @species
    iconbitmap = AnimatedBitmap.new("Graphics/Pictures/Triple Triad/Cards/#{filename}")
    # iconbitmap = AnimatedBitmap.new(GameData::Species.icon_filename(@species, @form))
    numbersbitmap = AnimatedBitmap.new("Graphics/Pictures/triad_numbers")
    # Draw card background
    bitmap.blt(0, 0, cardbitmap.bitmap, Rect.new(0, 0, cardbitmap.width, cardbitmap.height))
    # typebitmap = AnimatedBitmap.new(_INTL("Graphics/Pictures/types"))
    # type_number = GameData::Type.get(@type).icon_position
    # typerect = Rect.new(0, type_number * 28, 64, 28)
    typebitmap = AnimatedBitmap.new("Graphics/Pictures/Triple Triad/types/#{@type}")
    
    # Draw Pokémon icon
    bitmap.blt(0, 0, iconbitmap.bitmap, Rect.new(0, 0, 80, 96))
    # Draw type icon
    # bitmap.blt(57, 7, typebitmap.bitmap, Rect.new(0, 0, 16, 16))
    # Draw numbers
    bitmap.blt(32, 60, numbersbitmap.bitmap, Rect.new(@north * 16, 0, 16, 16))
    bitmap.blt(14, 69, numbersbitmap.bitmap, Rect.new(@west * 16, 0, 16, 16))
    bitmap.blt(50, 69, numbersbitmap.bitmap, Rect.new(@east * 16, 0, 16, 16))
    bitmap.blt(32, 76, numbersbitmap.bitmap, Rect.new(@south * 16, 0, 16, 16))
    cardbitmap.dispose
    typebitmap.dispose
    iconbitmap.dispose
    numbersbitmap.dispose
    return bitmap
  end


end  


#===============================================================================
# New Card shop screen
#===============================================================================
def pbBuyTriads(species = [])
    commands = []
    realcommands = []
    Console.echo_li("pbBuyTriads here")
    if species.length > 0
        Console.echo_li("pbBuyTriads here 2 #{species}")
        for s in species
            Console.echo_li("pbBuyTriads here 3 #{s}")

            loaded = GameData::Species.get(s)
            price = TriadCard.new(loaded.id).price
            commands.push([price, loaded.name, _INTL("{1} - ${2}", loaded.name, price.to_s_formatted), loaded.id])
        end
    else
    #     # If no param is passed, we use the default logic to show cards for Pokémon the player already own
        GameData::Species.each_species do |s|
            next if !$player.owned?(s.species)
            price = TriadCard.new(s.id).price
            commands.push([price, s.name, _INTL("{1} - ${2}", s.name, price.to_s_formatted), s.id])
        end    
    end
    if commands.length == 0
      pbMessage(_INTL("There are no cards that you can buy."))
      return
    end
    commands.sort! { |a, b| a[1] <=> b[1] }   # Sort alphabetically
    commands.each do |command|
      realcommands.push(command[2])
    end
    # Scroll right before showing screen
    pbScrollMap(4, 3, 5)
    cmdwindow = Window_CommandPokemonEx.newWithSize(realcommands, 0, 0, Graphics.width / 2, Graphics.height)
    cmdwindow.z = 99999
    goldwindow = Window_UnformattedTextPokemon.newWithSize(
      _INTL("Money:\r\n{1}", pbGetGoldString), 0, 0, 32, 32
    )
    goldwindow.resizeToFit(goldwindow.text, Graphics.width)
    goldwindow.x = Graphics.width - goldwindow.width
    goldwindow.y = 0
    goldwindow.z = 99999
    preview = Sprite.new
    preview.x = (Graphics.width * 3 / 4) - 40
    preview.y = (Graphics.height / 2) - 48
    preview.z = 4
    preview.bitmap = TriadCard.new(commands[cmdwindow.index][3]).createBitmap(1)
    olditem = commands[cmdwindow.index][3]
    Graphics.frame_reset
    loop do
      Graphics.update
      Input.update
      cmdwindow.active = true
      cmdwindow.update
      goldwindow.update
      if commands[cmdwindow.index][3] != olditem
        preview.bitmap&.dispose
        preview.bitmap = TriadCard.new(commands[cmdwindow.index][3]).createBitmap(1)
        olditem = commands[cmdwindow.index][3]
      end
      if Input.trigger?(Input::BACK)
        break
      elsif Input.trigger?(Input::USE)
        price    = commands[cmdwindow.index][0]
        item     = commands[cmdwindow.index][3]
        itemname = commands[cmdwindow.index][1]
        cmdwindow.active = false
        cmdwindow.update
        if $player.money < price
          pbMessage(_INTL("You don't have enough money."))
          next
        end
        maxafford = (price <= 0) ? 99 : $player.money / price
        maxafford = 99 if maxafford > 99
        params = ChooseNumberParams.new
        params.setRange(1, maxafford)
        params.setInitialValue(1)
        params.setCancelValue(0)
        quantity = pbMessageChooseNumber(
          _INTL("The {1} card? Certainly. How many would you like?", itemname), params
        )
        next if quantity <= 0
        price *= quantity
        next if !pbConfirmMessage(_INTL("{1}, and you want {2}. That will be ${3}. OK?", itemname, quantity, price.to_s_formatted))
        if $player.money < price
          pbMessage(_INTL("You don't have enough money."))
          next
        end
        if !$PokemonGlobal.triads.can_add?(item, quantity)
          pbMessage(_INTL("You have no room for more cards."))
          next
        end
        $PokemonGlobal.triads.add(item, quantity)
        $player.money -= price
        goldwindow.text = _INTL("Money:\r\n{1}", pbGetGoldString)
        pbMessage(_INTL("Here you are! Thank you!\\se[Mart buy item]"))
      end
    end
    cmdwindow.dispose
    goldwindow.dispose
    preview.bitmap&.dispose
    preview.dispose
    Graphics.frame_reset
    # Scroll right before showing screen
    pbScrollMap(6, 3, 5)
end


#===============================================================================
# New Triad List simulating a TCG binder
#===============================================================================
def pbTriadBinder
  # pbTriadList() # For now, let's just call the old method
  # Once we finish the script below, we can start using it.
    scene = TripleTriadBinder_Scene.new
    screen = TripleTriadBinderScreen.new(scene)
    screen.pbStartScreen()
   
end