TOTAL_COLUMNS = 6
TOTAL_VISIBLE_ROWS = 3
CARD_WIDTH = 82 # Extra 2px for spacing
CARD_HEIGHT = 98 # Extra 2px for spacing
START_X_POS = 10
START_Y_POS = 24
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

    @selCard    = @cardOffset * TOTAL_COLUMNS
    @oldselribbon = @selCard
    @switching = false
    @numCards = @cards.length
    @numRows    = [((@numCards + TOTAL_VISIBLE_ROWS) / TOTAL_COLUMNS).floor, TOTAL_VISIBLE_ROWS].max

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
    @sprites["uparrow"].visible   = false
    @sprites["downarrow"].visible = false
    # Write various bits of text
    textpos = [
      [_INTL("No. of Cards:"), 234, 2, 0, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [@numCards.to_s, 450, 2, 1, Color.new(64, 64, 64), Color.new(176, 176, 176)]
    ]
    # Draw all text
    pbDrawTextPositions(overlay, textpos)
    # Show all ribbons
    imagepos = []
    coord = 0
    (@cardOffset * TOTAL_COLUMNS...(@cardOffset * TOTAL_COLUMNS) + (TOTAL_COLUMNS * TOTAL_VISIBLE_ROWS)).each do |i|
      Console.echo_li("WILL BREAK -- #{!@cards[i]}")
      # break if !@cards[i]

      if !@cards[i]
        # There's some bug on how I'm displaying the cards, so I can't break here, as it adds repeated cards somehow
        # To overcome this, I'm then displaying the first card of the deck, but with createModifiedBitmap(0)
        # which generates a flipped card
        # @todo: improve this!!
        bitmapCard = TriadCard.new(@cards[0][0]).createModifiedBitmap(0)
      else  
        bitmapCard = TriadCard.new(@cards[i][0]).createModifiedBitmap(1)
      end
    imagepos.push([bitmapCard, 
    START_X_POS + (CARD_WIDTH * (coord % TOTAL_COLUMNS)), START_Y_POS + (CARD_HEIGHT * (coord / TOTAL_COLUMNS).floor)])
    coord += 1
  end
  # Draw all images
  pbDrawImagePositionsModified(overlay, imagepos)
  end


  def pbDrawImagePositionsModified(bitmap, textpos)
    textpos.each do |i|
      srcbitmap = i[0]
      x = i[1]
      y = i[2]
      srcx = i[3] || 0
      srcy = i[4] || 0
      width = (i[5] && i[5] >= 0) ? i[5] : srcbitmap.width
      height = (i[6] && i[6] >= 0) ? i[6] : srcbitmap.height
      srcrect = Rect.new(srcx, srcy, width, height)
      bitmap.blt(x, y, srcbitmap, srcrect)
      srcbitmap.dispose
    end
  end


  

  def drawSelectedRibbon(cardIndex)
    # Draw all of page
    drawPage

    overlay = @sprites["overlay"].bitmap
    base   = Color.new(64, 64, 64)
    shadow = Color.new(176, 176, 176)
    nameBase   = Color.new(248, 248, 248)
    nameShadow = Color.new(104, 104, 104)
    # Get data for selected ribbon
    if(cardIndex < @numCards)
      # item = $PokemonGlobal.triads[cardIndex]
      # species = GameData::Species.get(item[0])
  
      item = @cards[cardIndex]
      species = TriadCard.new(@cards[cardIndex][0])
      # species = GameData::Species.get(@cards[cardIndex][0])

      name = cardIndex ? species.name : ""
      Console.echo_li("Write something here #{item[1]}")
      desc = "X #{item[1]}"
      # Draw the description box
      imagepos = [
        ["Graphics/Pictures/Triple Triad/overlay", 8, 320]
      ]
      pbDrawImagePositions(overlay, imagepos)
      # Draw name of selected ribbon
      textpos = [
        [name, 18, 323, 0, nameBase, nameShadow]
      ]
      pbDrawTextPositions(overlay, textpos)
      # Draw selected ribbon's description
      drawTextEx(overlay, 18, 332, 480, 2, desc, base, shadow)
    end  
    
  end

  def pbScene
    hasMovedCursor = false
    switching = false
    @sprites["cardsel"].visible = true
    @sprites["cardsel"].index   = 0
    
    drawSelectedRibbon(0)

    loop do
      @sprites["uparrow"].visible   = (@cardOffset > 0)
      @sprites["downarrow"].visible = (@cardOffset < @numRows - TOTAL_VISIBLE_ROWS)
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
          @selCard -= TOTAL_COLUMNS
          @selCard += @numRows * TOTAL_COLUMNS if @selCard < 0
          hasMovedCursor = true
          pbPlayCursorSE
      elsif Input.trigger?(Input::DOWN)
          @selCard += TOTAL_COLUMNS
          @selCard -= @numRows * TOTAL_COLUMNS if @selCard >= @numRows * TOTAL_COLUMNS
          hasMovedCursor = true
          pbPlayCursorSE
      elsif Input.trigger?(Input::LEFT)
          @selCard -= 1
          @selCard += TOTAL_COLUMNS if @selCard % TOTAL_COLUMNS == TOTAL_COLUMNS-1
          hasMovedCursor = true
          pbPlayCursorSE
      elsif Input.trigger?(Input::RIGHT)
          @selCard += 1
          @selCard -= TOTAL_COLUMNS if @selCard % TOTAL_COLUMNS == 0
          hasMovedCursor = true
          pbPlayCursorSE
      end    
        next if !hasMovedCursor
        @cardOffset = (@selCard / TOTAL_COLUMNS).floor if @selCard < @cardOffset * TOTAL_COLUMNS
        @cardOffset = (@selCard / TOTAL_COLUMNS).floor - (TOTAL_VISIBLE_ROWS - 1) if @selCard >= (@cardOffset + TOTAL_VISIBLE_ROWS) * TOTAL_COLUMNS
        @cardOffset = 0 if @cardOffset < 0
        @cardOffset = @numRows - (TOTAL_VISIBLE_ROWS) if @cardOffset > @numRows - (TOTAL_VISIBLE_ROWS)
        @sprites["cardsel"].index    = @selCard - (@cardOffset * TOTAL_COLUMNS)
        @sprites["cardpresel"].index = @oldselribbon - (@cardOffset * TOTAL_COLUMNS)
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
    self.x = (START_X_POS-2) + ((self.index % TOTAL_COLUMNS) * CARD_WIDTH)
    self.y = (START_Y_POS-2) + ((self.index / TOTAL_COLUMNS).floor * CARD_HEIGHT)
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
    self.visible = @spriteVisible && @index >= 0 && @index < (TOTAL_COLUMNS * TOTAL_VISIBLE_ROWS)
    @movesel.update
    @updating = false
    refresh
  end
end