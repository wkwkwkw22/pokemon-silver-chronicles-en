class TripleTriadBinder_Scene
  def pbUpdate
    pbUpdateSpriteHash(@sprites)
  end

  def main
   
  end

  def pbStartScene()
    @ribbonOffset = 0
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @sprites = {}
    @partyindex = 0
    @pokemon = $player.party[0]
    @sprites["background"] = IconSprite.new(0, 0, @viewport)
    @sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    @sprites["ribbonpresel"] = RibbonSelectionSprite.new(@viewport)
    @sprites["ribbonpresel"].visible     = false
    @sprites["ribbonpresel"].preselected = true
    @sprites["ribbonsel"] = RibbonSelectionSprite.new(@viewport)
    @sprites["ribbonsel"].visible = false
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
    @nationalDexList = [:NONE]
    GameData::Species.each_species { |s| @nationalDexList.push(s.species) }

    @selribbon    = @ribbonOffset * 4
    @oldselribbon = @selribbon
    @switching = false
    @numRibbons = @pokemon.ribbons.length
    @numRows    = [((@numRibbons + 3) / 4).floor, 3].max


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

  def pbConfirm(text)
    ret = -1
    @sprites["messagebox"].text    = text
    @sprites["messagebox"].visible = true
    using(cmdwindow = Window_CommandPokemon.new([_INTL("Yes"), _INTL("No")])) {
      cmdwindow.z       = @viewport.z + 1
      cmdwindow.visible = false
      pbBottomRight(cmdwindow)
      cmdwindow.y -= @sprites["messagebox"].height
      loop do
        Graphics.update
        Input.update
        cmdwindow.visible = true if !@sprites["messagebox"].busy?
        cmdwindow.update
        pbUpdate
        if !@sprites["messagebox"].busy?
          if Input.trigger?(Input::BACK)
            ret = false
            break
          elsif Input.trigger?(Input::USE) && @sprites["messagebox"].resume
            ret = (cmdwindow.index == 0)
            break
          end
        end
      end
    }
    @sprites["messagebox"].visible = false
    return ret
  end


  def pbShowCommands(commands, index = 0)
    ret = -1
    using(cmdwindow = Window_CommandPokemon.new(commands)) {
      cmdwindow.z = @viewport.z + 1
      cmdwindow.index = index
      pbBottomRight(cmdwindow)
      loop do
        Graphics.update
        Input.update
        cmdwindow.update
        pbUpdate
        if Input.trigger?(Input::BACK)
          pbPlayCancelSE
          ret = -1
          break
        elsif Input.trigger?(Input::USE)
          pbPlayDecisionSE
          ret = cmdwindow.index
          break
        end
      end
    }
    return ret
  end


  # def drawPage(page)
    
  #   overlay = @sprites["overlay"].bitmap
  #   overlay.clear
  #   # Set background image
  #   @sprites["background"].setBitmap("Graphics/Pictures/Summary/bg_#{page}")
  #   imagepos = []
    
  #   # Draw all images
  #   pbDrawImagePositions(overlay, imagepos)
  #   # Write various bits of text
  #   # pagename = [_INTL("INFO"),
  #   #             _INTL("TRAINER MEMO"),
  #   #             _INTL("SKILLS"),
  #   #             _INTL("MOVES"),
  #   #             _INTL("RIBBONS")][page - 1]
  #   # textpos = [
  #   #   [pagename, 26, 22, 0, base, shadow],
  #   #   [@pokemon.name, 46, 68, 0, base, shadow],
  #   #   [@pokemon.level.to_s, 46, 98, 0, Color.new(64, 64, 64), Color.new(176, 176, 176)],
  #   #   [_INTL("Item"), 66, 324, 0, base, shadow]
  #   # Write the held item's name
    
  #   # Draw all text
  #   # pbDrawTextPositions(overlay, textpos)
  #   # Draw the Pokémon's markings
  #   # drawMarkings(overlay, 84, 292)
  #   # Draw page-specific information
  #   drawPageFive
    
  # end


  def drawPage
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    # Set background image
    @sprites["background"].setBitmap("Graphics/Pictures/Summary/bg_5")
    imagepos = []
    
    # Draw all images
    pbDrawImagePositions(overlay, imagepos)
    overlay = @sprites["overlay"].bitmap
    @sprites["uparrow"].visible   = false
    @sprites["downarrow"].visible = false
    # Write various bits of text
    textpos = [
      [_INTL("No. of Ribbons:"), 234, 338, 0, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [@pokemon.numRibbons.to_s, 450, 338, 1, Color.new(64, 64, 64), Color.new(176, 176, 176)]
    ]
    # Draw all text
    pbDrawTextPositions(overlay, textpos)
    # Show all ribbons
    imagepos = []
    coord = 0
    Console.echo_li("Arrived here #{@ribbonOffset}")
    (@ribbonOffset * 4...(@ribbonOffset * 4) + 12).each do |i|
      break if !@pokemon.ribbons[i]
      ribbon_data = GameData::Ribbon.get($player.party[0].ribbons[i])
      ribn = ribbon_data.icon_position
      imagepos.push(["Graphics/Pictures/ribbons",
                     230 + (68 * (coord % 4)), 78 + (68 * (coord / 4).floor),
                     64 * (ribn % 8), 64 * (ribn / 8).floor, 64, 64])
      coord += 1
    end
    # Draw all images
    pbDrawImagePositions(overlay, imagepos)
  end

  def drawSelectedRibbon(ribbonid)
    # Draw all of page five
    drawPage # @todo: confirm if really need this line
    # Set various values
    overlay = @sprites["overlay"].bitmap
    base   = Color.new(64, 64, 64)
    shadow = Color.new(176, 176, 176)
    nameBase   = Color.new(248, 248, 248)
    nameShadow = Color.new(104, 104, 104)
    # Get data for selected ribbon
    name = ribbonid ? GameData::Ribbon.get(ribbonid).name : ""
    desc = ribbonid ? GameData::Ribbon.get(ribbonid).description : ""
    # Draw the description box
    imagepos = [
      ["Graphics/Pictures/Summary/overlay_ribbon", 8, 280]
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

  def pbScene
    @pokemon.play_cry
    hasMovedCursor = false
    switching = false
    @sprites["ribbonsel"].visible = true
    @sprites["ribbonsel"].index   = 0
    drawSelectedRibbon(@pokemon.ribbons[@selribbon])

    loop do
      @sprites["uparrow"].visible   = (@ribbonOffset > 0)
      @sprites["downarrow"].visible = (@ribbonOffset < @numRows - 3)
      Graphics.update
      Input.update
      pbUpdate
      dorefresh = false
      if @sprites["ribbonpresel"].index == @sprites["ribbonsel"].index
         @sprites["ribbonpresel"].z = @sprites["ribbonsel"].z + 1
      else
        @sprites["ribbonpresel"].z = @sprites["ribbonsel"].z
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
          @sprites["ribbonpresel"].visible = false
          switching = false
        #  break
        # elsif Input.trigger?(Input::USE)
        #     pbPlayDecisionSE
        #     pbRibbonSelection
        #     dorefresh = true
        # if Input.trigger?(Input::BACK)
        #   (switching) ? pbPlayCancelSE : pbPlayCloseMenuSE
        #   break if !switching
        #   @sprites["ribbonpresel"].visible = false
        #   switching = false
      elsif Input.trigger?(Input::USE)
          if switching
            pbPlayDecisionSE
            tmpribbon                      = @pokemon.ribbons[@oldselribbon]
            @pokemon.ribbons[@oldselribbon] = @pokemon.ribbons[@selribbon]
            @pokemon.ribbons[@selribbon]    = tmpribbon
            if @pokemon.ribbons[@oldselribbon] || @pokemon.ribbons[@selribbon]
              @pokemon.ribbons.compact!
              if @selribbon >= @numRibbons
                @selribbon = @numRibbons - 1
                hasMovedCursor = true
              end
            end
            @sprites["ribbonpresel"].visible = false
            switching = false
            drawSelectedRibbon(@pokemon.ribbons[@selribbon])
            dorefresh = true
          else
            if @pokemon.ribbons[@selribbon]
              pbPlayDecisionSE
              @sprites["ribbonpresel"].index = @selribbon - (@ribbonOffset * 4)
              @oldselribbon = @selribbon
              @sprites["ribbonpresel"].visible = true
              switching = true
            end
          end
      elsif Input.trigger?(Input::UP)
          @selribbon -= 4
          @selribbon += @numRows * 4 if @selribbon < 0
          hasMovedCursor = true
          pbPlayCursorSE
      elsif Input.trigger?(Input::DOWN)
          @selribbon += 4
          @selribbon -= @numRows * 4 if @selribbon >= @numRows * 4
          hasMovedCursor = true
          pbPlayCursorSE
      elsif Input.trigger?(Input::LEFT)
          @selribbon -= 1
          @selribbon += 4 if @selribbon % 4 == 3
          hasMovedCursor = true
          pbPlayCursorSE
      elsif Input.trigger?(Input::RIGHT)
          @selribbon += 1
          @selribbon -= 4 if @selribbon % 4 == 0
          hasMovedCursor = true
          pbPlayCursorSE
      end    
        next if !hasMovedCursor
        @ribbonOffset = (@selribbon / 4).floor if @selribbon < @ribbonOffset * 4
        @ribbonOffset = (@selribbon / 4).floor - 2 if @selribbon >= (@ribbonOffset + 3) * 4
        @ribbonOffset = 0 if @ribbonOffset < 0
        @ribbonOffset = @numRows - 3 if @ribbonOffset > @numRows - 3
        @sprites["ribbonsel"].index    = @selribbon - (@ribbonOffset * 4)
        @sprites["ribbonpresel"].index = @oldselribbon - (@ribbonOffset * 4)
        drawSelectedRibbon(@pokemon.ribbons[@selribbon])
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


class RibbonSelectionSprite < MoveSelectionSprite
  def initialize(viewport = nil)
    super(viewport)
    @movesel = AnimatedBitmap.new("Graphics/Pictures/Summary/cursor_ribbon")
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