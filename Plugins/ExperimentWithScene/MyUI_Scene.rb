#===============================================================================
#
#===============================================================================
class MyUI::Scene

  attr_reader :viewport, :sprites, :pokemon


  #-----------------------------------------------------------------------------
  #  updates scene graphics
  #-----------------------------------------------------------------------------
  def pbGraphicsUpdate
    Graphics.update
  end
  def pbUpdate(cw = nil)
    pbGraphicsUpdate
    # pbInputUpdate
    # pbFrameUpdate(cw)

    # pbUpdateSpriteHash(@sprites)
  end
  # def pbUpdate
  #   pbUpdateSpriteHash(@sprites)
  # end


  #-----------------------------------------------------------------------------
  # battler sprite positioning
  #-----------------------------------------------------------------------------
  def delta; return Graphics.frame_rate/40.0; end
  def scale_y; return @sprites["bg"].zoom_y; end
  def battler(i); return @sprites["battler#{i}"]; end
  def trainer(i); return @sprites["trainer_#{i}"]; end
  # def stageLightPos(j)
  #   data = EliteBattle.get(:battlerMetrics)
  #   return if data.nil?
  #   x = 0; y = 0
  #   for param in [:X, :Y, :Z]
  #     next if data[j].nil? || !data[j].has_key?(param)
  #     dat = data[j][param]
  #     x = dat[0] if param == :X
  #     y = dat[0] if param == :Y
  #   end
  #   return x, y
  # end
  def spoof(vector, index = 1)
    target = self.battler(index)
    bx, by = @scene.vector.spoof(vector)
    # updates to the spatial warping with respect to the scene vector
    dx, dy = @scene.vector.spoof(@defaultvector)
    bzoom_x = @scale*((bx - vector[0])*1.0/(dx - @defaultvector[0])*1.0)**0.6
    bzoom_y = @scale*((by - vector[1])*1.0/(dy - @defaultvector[1])*1.0)**0.6
    x = bx - (@sprites["bg"].ox - target.ex)*bzoom_x
    y = by - (@sprites["bg"].oy - target.ey)*bzoom_y
    return x, y
  end

  def pbStartScene
    PBDebug.log("")
    PBDebug.log("START MY SCENE")

    @orgPos = nil
    # @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    # @viewport.z = 99999
    # @sprites = {}
    # background = pbResolveBitmap(sprintf("Graphics/Pictures/Trainer Card/bg_f"))
    # if $player.female? && background
    #   addBackgroundPlane(@sprites, "bg", "Trainer Card/bg_f", @viewport)
    # else
    #   addBackgroundPlane(@sprites, "bg", "Trainer Card/bg", @viewport)
    # end
    # cardexists = pbResolveBitmap(sprintf("Graphics/Pictures/Trainer Card/card_f"))
    # @sprites["card"] = IconSprite.new(0, 0, @viewport)
    # if $player.female? && cardexists
    #   @sprites["card"].setBitmap("Graphics/Pictures/Trainer Card/card_f")
    # else
    #   @sprites["card"].setBitmap("Graphics/Pictures/Trainer Card/card")
    # end
    # @sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    # pbSetSystemFont(@sprites["overlay"].bitmap)
    # @sprites["trainer"] = IconSprite.new(336, 112, @viewport)
    # @sprites["trainer"].setBitmap(GameData::TrainerType.player_front_sprite_filename($player.trainer_type))
    # @sprites["trainer"].x -= (@sprites["trainer"].bitmap.width - 128) / 2
    # @sprites["trainer"].y -= (@sprites["trainer"].bitmap.height - 128)
    # @sprites["trainer"].z = 2





    # vec = MyUI.get_vector(:ENEMY)
    # vec = MyUI.get_vector(:MAIN, nil)


    MyUI.add_vector(:PLAYER,
            238, 332,
            32,
            292,
            1
    )

    vec = MyUI.get_vector(:PLAYER, nil)

    vec[0] -= Graphics.width/2
    @vector = Vector.new(*vec)
    @sprites = {}
    # @vector.battle = @battle

    # viewport setup
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999

   

    @sprites["bg"] = Sprite.new(@viewport)
    @sprites["bg"].z = 0
    tbmp = pbBitmap("Graphics/Pictures/Trainer Card/card")
    @sprites["bg"].bitmap = Bitmap.new(tbmp.width, tbmp.height)
    @sprites["bg"].bitmap.blt(0, 0, tbmp, tbmp.rect)
    tbmp.dispose


    plfile = GameData::TrainerType.player_front_sprite_filename($player.trainer_type)
    pbAddSprite("player", 0, 0, plfile, @viewport)

    if @sprites["player"].bitmap.nil?
      Console.echo_li "ARRIVED DIDNT LOAD PLAYER BITMAP"
    end

    @sprites["player"] = Sprite.new(@viewport)
    @sprites["player"].x = 40 * 100
    # @sprites["player"].y = Graphics.height - @sprites["player"].bitmap.height
    @sprites["player"].y = 50

    @sprites["player"].z = 50
    @sprites["player"].opacity = 0
    @sprites["player"].src_rect.width /= 5


    @vector.force
    @vector.set(vec)
    @vector.inc = 0.1

    self.wait(60, true)
    @vector.inc = 0.2


    self.moveEntireScene(-200,-200,true,false)
    self.wait(1,false)

    self.animateScene(true)

    @vector.spoof(@vector)
    @sprites["bg"].zoom_x = 10
    @sprites["bg"].zoom_y = 10

    # if @sprites["bg"].bitmap
    #   @sprites["bg"].center!
    #   @sprites["bg"].ox = sx/1.5 - 16
    #   @sprites["bg"].oy = sy/1.5 + 16
    #   if @baseBmp
    #     @sprites["bg"].bitmap.blt(0, @sprites["bg"].bitmap.height - @baseBmp.height, @baseBmp, @baseBmp.rect)
    #   end
    #   c1 = @sprites["bg"].bitmap.get_pixel(0, 0)
    #   c2 = @sprites["bg"].bitmap.get_pixel(0, @sprites["bg"].bitmap.height-1)
    #   @sprites["void"].bitmap.fill_rect(0, 0, @viewport.width, @viewport.height/2, c1)
    #   @sprites["void"].bitmap.fill_rect(0, @viewport.height/2, @viewport.width, @viewport.height/2, c2)
    # end

    # battler sprite positioning
    self.adjustMetrics

    # pbFadeInAndShow(@sprites) { pbUpdate }
  end

  def pbAddSprite(id, x, y, filename, viewport)
    sprite = @sprites[id] || IconSprite.new(x, y, viewport)
    if filename
      sprite.setBitmap(filename) rescue nil
    end
    @sprites[id] = sprite
    return sprite
  end


  def adjustMetrics
    # Still need to understand what this does
    # @scale = EliteBattle::ROOM_SCALE
    @scale = 2
    # data = MyUI.get(:battlerMetrics)
    # for j in -2...data.keys.length
    #   @sprites["battler#{j}"] = Sprite.new(@viewport)
    #   @sprites["battler#{j}"].default!
    #   @sprites["trainer_#{j}"] = Sprite.new(@viewport)
    #   @sprites["trainer_#{j}"].default!
    #   i = j; i = 0 if j == -2; i = 1 if j == -1
    #   for param in [:X, :Y, :Z]
    #     next if !data[i].has_key?(param)
    #     dat = data[i][param]
    #     n = [@battle.pbMaxSize - 1, @battle.pbMaxSize(j%2) - 1].min - i/2
    #     m = (@battle.opponent ? [@battle.pbMaxSize - 1, @battle.pbMaxSize(j%2) - 1, (@battle.opponent.length - 1)].min : n) - i/2
    #     n = dat.length - 1 if n >= dat.length
    #     m = dat.length - 1 if m >= dat.length
    #     n = 0 if n < 0; m = 0 if m < 0
    #     k = [:X, :Y].include?(param) ? "E#{param.to_s}" : param.to_s
    #     @sprites["battler#{j}"].send("#{k.downcase}=", dat[n])
    #     @sprites["trainer_#{j}"].send("#{k.downcase}=", dat[m])
    #   end
    # end
  end

  

  def pbMyUI
    pbSEPlay("GUI trainer card open")
    loop do
      Graphics.update
      Input.update
      pbUpdate
      if Input.trigger?(Input::BACK)
        pbPlayCloseMenuSE
        break
      end
    end
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites) { pbUpdate }
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
end

#===============================================================================
#
#===============================================================================
class MyUIScreen
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen
    @scene.pbStartScene
    @scene.pbMyUI
    @scene.pbEndScene
  end
end
