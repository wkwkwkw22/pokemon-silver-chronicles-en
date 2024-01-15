class TripleTriadBinder_Scene
  def pbUpdate
    pbUpdateSpriteHash(@sprites)
  end


  def pbStartScene()
    @cardOffset = 0
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @sprites = {}
    @partyindex = 0

    @cards = $PokemonGlobal.triads

    addBackgroundPlane(@sprites, "background", "Triple Triad/bg", @viewport)

    @sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    @sprites["cardpresel"] = CardSelectionSprite.new(@viewport)
    @sprites["cardpresel"].visible     = false
    @sprites["cardpresel"].preselected = true
    @sprites["cardsel"] = CardSelectionSprite.new(@viewport)
    @sprites["cardsel"].visible = false
    @sprites["uparrow"] = AnimatedSprite.new("Graphics/Pictures/uparrow", 8, 28, 40, 2, @viewport)
    @sprites["uparrow"].x = 350
    @sprites["uparrow"].y = 56
    @sprites["uparrow"].play
    @sprites["uparrow"].visible = false
    @sprites["downarrow"] = AnimatedSprite.new("Graphics/Pictures/downarrow", 8, 28, 40, 2, @viewport)
    @sprites["downarrow"].x = 350
    @sprites["downarrow"].y = 260
    @sprites["downarrow"].play
    @sprites["downarrow"].visible = false
    @sprites["messagebox"] = Window_AdvancedTextPokemon.new("")
    @sprites["messagebox"].viewport       = @viewport
    @sprites["messagebox"].visible        = false
    @sprites["messagebox"].letterbyletter = true
    pbBottomLeftLines(@sprites["messagebox"], 2)

    @selCard    = @cardOffset * 4
    @oldselribbon = @selCard
    @switching = false
    @numCards = @cards.length
    @numRows    = [((@numCards + 3) / 4).floor, 3].max

    drawPage()
    pbFadeInAndShow(@sprites) { pbUpdate }
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites) { pbUpdate }
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end

  def pbDisplay(text)
    @sprites["messagebox"].text = text
    @sprites["messagebox"].visible = true
    pbPlayDecisionSE
    loop do
      Graphics.update
      Input.update
      pbUpdate
      if @sprites["messagebox"].busy?
        if Input.trigger?(Input::USE)
          pbPlayDecisionSE if @sprites["messagebox"].pausing?
          @sprites["messagebox"].resume
        end
      elsif Input.trigger?(Input::USE) || Input.trigger?(Input::BACK)
        break
      end
    end
    @sprites["messagebox"].visible = false
  end

  def drawPage
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    # Set background image
    
    imagepos = []
    
    # Draw all images
    pbDrawImagePositions(overlay, imagepos)
    overlay = @sprites["overlay"].bitmap
    @sprites["uparrow"].visible   = false
    @sprites["downarrow"].visible = false
    # Write various bits of text
    textpos = [
      [_INTL("No. of Cards:"), 234, 10, 0, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [@numCards.to_s, 450, 10, 1, Color.new(64, 64, 64), Color.new(176, 176, 176)]
    ]
    # Draw all text
    pbDrawTextPositions(overlay, textpos)
    # Show all ribbons
    imagepos = []
    coord = 0
    Console.echo_li("Arrived here #{@cardOffset}")
    (@cardOffset * 4...(@cardOffset * 4) + 12).each do |i|
      break if !@cards[i]
      # ribbon_data = GameData::Ribbon.get($player.party[0].ribbons[i])
      # ribbon_data = GameData::Ribbon.get($player.party[0].ribbons[i])
      # ribn = ribbon_data.icon_position
      # imagepos.push(["Graphics/Pictures/ribbons",
      #                230 + (68 * (coord % 4)), 78 + (68 * (coord / 4).floor),
      #                64 * (ribn % 8), 64 * (ribn / 8).floor, 64, 64])

      sprite = Sprite.new(@viewport)
      sprite.x = 230 + (68 * (coord % 4))
      sprite.y = 78 + (68 * (coord / 4).floor)
      sprite.z = 0
      # sprite.bitmap = Bitmap.new("Graphics/Pictures/Triple Triad/triad_card_player")
      sprite.bitmap = TriadCard.new($PokemonGlobal.triads.get_item(i)).createBitmap(1)
      sprite.visible = true
      @sprites["card_#{coord}"] = sprite

      # sprite.bitmap = BitmapWrapper.new(@bgbitmap.width, 222)

      # pbDisposeSpriteHash(@sprites)


      Console.echo_li("Arrived here #{sprite.bitmap}")

      # srcbitmap = AnimatedBitmap.new(pbBitmapName(i[0]))
      # x = i[1]
      # y = i[2]
      # srcx = i[3] || 0
      # srcy = i[4] || 0
      # width = (i[5] && i[5] >= 0) ? i[5] : srcbitmap.width
      # height = (i[6] && i[6] >= 0) ? i[6] : srcbitmap.height
      # srcrect = Rect.new(0, 0, sprite.bitmap.width, sprite.bitmap.height)
      # sprite.bitmap.blt(0, 0, sprite.bitmap, srcrect)
      # srcbitmap.dispose

      # imagepos.push([bitmapCard, 
      #               230 + (68 * (coord % 4)), 78 + (68 * (coord / 4).floor)])

      # imagepos.push(["Graphics/Pictures/Triple Triad/triad_card_player", 
      #               230 + (68 * (coord % 4)), 78 + (68 * (coord / 4).floor)])
      coord += 1
    end
    # Draw all images
    pbDrawImagePositions(overlay, imagepos)
  end

  def drawSelectedRibbon(cardIndex)
    overlay = @sprites["overlay"].bitmap
    base   = Color.new(64, 64, 64)
    shadow = Color.new(176, 176, 176)
    nameBase   = Color.new(248, 248, 248)
    nameShadow = Color.new(104, 104, 104)
    # Get data for selected ribbon
    # name = ribbonid ? GameData::Ribbon.get(ribbonid).name : ""
    # desc = ribbonid ? GameData::Ribbon.get(ribbonid).description : ""
    Console.echo_li("Arrived here #{cardIndex}")
    if(cardIndex < @numCards)
      item = $PokemonGlobal.triads[cardIndex]
      species = GameData::Species.get(item[0])
  
      name = cardIndex ? species.name : ""
      Console.echo_li("Write something here #{item[1]}")
      desc = "X #{item[1]}"
      # Draw the description box
      imagepos = [
        ["Graphics/Pictures/Triple Triad/overlay", 8, 280]
      ]
      pbDrawImagePositions(overlay, imagepos)
      # Draw name of selected ribbon
      textpos = [
        [name, 18, 292, 0, nameBase, nameShadow]
      ]
      pbDrawTextPositions(overlay, textpos)
      # Draw selected ribbon's description
      drawTextEx(overlay, 18, 324, 480, 2, desc, base, shadow)
    end  
    
  end

  def pbScene
    hasMovedCursor = false
    switching = false
    @sprites["cardsel"].visible = true
    @sprites["cardsel"].index   = 0
    Console.echo_li("Arrived here pbScene")
    Console.echo_li("Arrived here @selCard #{@selCard}")
    Console.echo_li("Arrived here @cards #{@cards}")
    Console.echo_li("Arrived here @cards[@selCard] #{@cards[@selCard]}")

    
    drawSelectedRibbon(0)
    # drawSelectedRibbon(@cards[@selCard])

    loop do
      @sprites["uparrow"].visible   = (@cardOffset > 0)
      @sprites["downarrow"].visible = (@cardOffset < @numRows - 3)
      Graphics.update
      Input.update
      pbUpdate
      dorefresh = false
      if @sprites["cardpresel"].index == @sprites["cardsel"].index
         @sprites["cardpresel"].z = @sprites["cardsel"].z + 1
      else
        @sprites["cardpresel"].z = @sprites["cardsel"].z
      end
      hasMovedCursor = false
      # if Input.trigger?(Input::ACTION)
      #   pbSEStop
      #   @pokemon.play_cry
      # els
      if Input.trigger?(Input::BACK)
         pbPlayCloseMenuSE
         (switching) ? pbPlayCancelSE : pbPlayCloseMenuSE
          break if !switching
          @sprites["cardpresel"].visible = false
          switching = false
        #  break
        # elsif Input.trigger?(Input::USE)
        #     pbPlayDecisionSE
        #     pbRibbonSelection
        #     dorefresh = true
        # if Input.trigger?(Input::BACK)
        #   (switching) ? pbPlayCancelSE : pbPlayCloseMenuSE
        #   break if !switching
        #   @sprites["cardpresel"].visible = false
        #   switching = false
      elsif Input.trigger?(Input::USE)
        pbPlayCancelSE
        # This part is not working, but will not worry about switching cards position for now
        # as I'm not even sure I want that
          # if switching
          #   pbPlayDecisionSE
          #   tmpribbon                      = @cards[@oldselribbon]
          #   Console.echo_li("tmpribbon @cards[@oldselribbon] #{@cards[@oldselribbon]}")
          #   Console.echo_li("@cards[@selCard] #{@cards[@selCard]}")
          #   @cards[@oldselribbon] = @cards[@selCard]
          #   @cards[@selCard]    = tmpribbon
          #   if @cards[@oldselribbon] || @cards[@selCard]
          #     @cards.compact!
          #     if @selCard >= @numCards
          #       @selCard = @numCards - 1
          #       hasMovedCursor = true
          #     end
          #   end
          #   @sprites["cardpresel"].visible = false
          #   switching = false
          #   drawSelectedRibbon(@selCard)
          #   dorefresh = true
          # else
          #   if @cards[@selCard]
          #     pbPlayDecisionSE
          #     @sprites["cardpresel"].index = @selCard - (@cardOffset * 4)
          #     @oldselribbon = @selCard
          #     @sprites["cardpresel"].visible = true
          #     switching = true
          #   end
          # end
      elsif Input.trigger?(Input::UP)
          @selCard -= 4
          @selCard += @numRows * 4 if @selCard < 0
          hasMovedCursor = true
          pbPlayCursorSE
      elsif Input.trigger?(Input::DOWN)
          @selCard += 4
          @selCard -= @numRows * 4 if @selCard >= @numRows * 4
          hasMovedCursor = true
          pbPlayCursorSE
      elsif Input.trigger?(Input::LEFT)
          @selCard -= 1
          @selCard += 4 if @selCard % 4 == 3
          hasMovedCursor = true
          pbPlayCursorSE
      elsif Input.trigger?(Input::RIGHT)
          @selCard += 1
          @selCard -= 4 if @selCard % 4 == 0
          hasMovedCursor = true
          pbPlayCursorSE
      end    
        next if !hasMovedCursor
        @cardOffset = (@selCard / 4).floor if @selCard < @cardOffset * 4
        @cardOffset = (@selCard / 4).floor - 2 if @selCard >= (@cardOffset + 3) * 4
        @cardOffset = 0 if @cardOffset < 0
        @cardOffset = @numRows - 3 if @cardOffset > @numRows - 3
        @sprites["cardsel"].index    = @selCard - (@cardOffset * 4)
        @sprites["cardpresel"].index = @oldselribbon - (@cardOffset * 4)
        drawSelectedRibbon(@selCard)
      if dorefresh
        drawPage()
      end
    end
    return @partyindex
  end
end

class TripleTriadBinderScreen
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen()
    @scene.pbStartScene()
    ret = @scene.pbScene
    @scene.pbEndScene
    return ret
  end
end




class TriadCard

  def createNewBitmap(owner)
    return TriadCard.createBack if owner == 0
    bitmap = BitmapWrapper.new(80, 96)
    if owner == 2   # Opponent
      cardbitmap = AnimatedBitmap.new("Graphics/Pictures/triad_card_opponent")
    else            # Player
      cardbitmap = AnimatedBitmap.new("Graphics/Pictures/triad_card_player")
    end
    typebitmap = AnimatedBitmap.new(_INTL("Graphics/Pictures/types"))
    iconbitmap = AnimatedBitmap.new(GameData::Species.icon_filename(@species, @form))
    numbersbitmap = AnimatedBitmap.new("Graphics/Pictures/triad_numbers")
    # Draw card background
    bitmap.blt(0, 0, cardbitmap.bitmap, Rect.new(0, 0, cardbitmap.width, cardbitmap.height))
    # Draw type icon
    type_number = GameData::Type.get(@type).icon_position
    typerect = Rect.new(0, type_number * 28, 64, 28)
    bitmap.blt(8, 50, typebitmap.bitmap, typerect, 192)
    # Draw Pokémon icon
    bitmap.blt(8, 24, iconbitmap.bitmap, Rect.new(0, 0, 64, 64))
    # Draw numbers
    bitmap.blt(8, 16, numbersbitmap.bitmap, Rect.new(@west * 16, 0, 16, 16))
    bitmap.blt(22, 6, numbersbitmap.bitmap, Rect.new(@north * 16, 0, 16, 16))
    bitmap.blt(36, 16, numbersbitmap.bitmap, Rect.new(@east * 16, 0, 16, 16))
    bitmap.blt(22, 26, numbersbitmap.bitmap, Rect.new(@south * 16, 0, 16, 16))
    cardbitmap.dispose
    typebitmap.dispose
    iconbitmap.dispose
    numbersbitmap.dispose
    return bitmap
  end


end  


class CardSelectionSprite < MoveSelectionSprite
  def initialize(viewport = nil)
    super(viewport)
    @movesel = AnimatedBitmap.new("Graphics/Pictures/Triple Triad/cursor_binder")
    @frame = 0
    @index = 0
    @preselected = false
    @updating = false
    @spriteVisible = true
    refresh
  end

  def visible=(value)
    super
    @spriteVisible = value if !@updating
  end

  def refresh
    w = @movesel.width
    h = @movesel.height / 2
    self.z = 2
    self.x = 228 + ((self.index % 4) * 68)
    self.y = 76 + ((self.index / 4).floor * 68)
    self.bitmap = @movesel.bitmap
    if self.preselected
      self.src_rect.set(0, h, w, h)
    else
      self.src_rect.set(0, 0, w, h)
    end
  end

  def update
    @updating = true
    super
    self.visible = @spriteVisible && @index >= 0 && @index < 12
    @movesel.update
    @updating = false
    refresh
  end
end