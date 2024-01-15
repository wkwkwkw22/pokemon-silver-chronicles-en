#==========================
# Triple Triad changes made by victordevjs
#==========================


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
def pbTriadList
    scene = TripleTriadBinder_Scene.new
    screen = TripleTriadBinderScreen.new(scene)
    screen.pbStartScreen()
    # total_cards = 0
    # commands = []
    # $PokemonGlobal.triads.length.times do |i|
    #   item = $PokemonGlobal.triads[i]
    #   speciesname = GameData::Species.get(item[0]).name
    #   commands.push(_INTL("{1} x{2}", speciesname, item[1]))
    #   total_cards += item[1]
    # end
    # commands.push(_INTL("CANCEL"))
    # if total_cards == 0
    #   pbMessage(_INTL("You have no cards."))
    #   return
    # end
    # cmdwindow = Window_CommandPokemonEx.newWithSize(commands, 0, 0, Graphics.width / 2, Graphics.height)
    # cmdwindow.z = 99999
    # sprite = Sprite.new
    # sprite.x = (Graphics.width / 2) + 40
    # sprite.y = 48
    # sprite.z = 99999
    # done = false
    # lastIndex = -1
    # until done
    #   loop do
    #     Graphics.update
    #     Input.update
    #     cmdwindow.update
    #     if lastIndex != cmdwindow.index
    #       sprite.bitmap&.dispose
    #       if cmdwindow.index < $PokemonGlobal.triads.length
    #         sprite.bitmap = TriadCard.new($PokemonGlobal.triads.get_item(cmdwindow.index)).createBitmap(1)
    #       end
    #       lastIndex = cmdwindow.index
    #     end
    #     if Input.trigger?(Input::BACK) ||
    #        (Input.trigger?(Input::USE) && cmdwindow.index >= $PokemonGlobal.triads.length)
    #       done = true
    #       break
    #     end
    #   end
    # end
    # cmdwindow.dispose
    # sprite.dispose
end