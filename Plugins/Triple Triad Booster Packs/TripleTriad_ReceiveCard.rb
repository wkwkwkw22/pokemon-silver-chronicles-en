class ReceiveCardScene 

  def initialize(card,quantity)
  @card=card
  @quantity=quantity
  end

  def pbStartScene
  @sprites={}
  @viewport=Viewport.new(0,0,Graphics.width,Graphics.height) # Updated DEFAULTSCREENHEIGHT
  @viewport.z=99999
  @finished=false
  
  @sprites["whitescreen"] = Sprite.new(@viewport)
  @sprites["whitescreen"].color=Color.new(255,255,255)
  @sprites["whitescreen"].opacity=0
  
  @sprites["bg"] = Sprite.new(@viewport)
  @sprites["bg"].bitmap = RPG::Cache.picture("keyitembg")
  @sprites["bg"].ox=@sprites["bg"].bitmap.width/2
  @sprites["bg"].oy=@sprites["bg"].bitmap.height/2
  @sprites["bg"].y=Settings::SCREEN_HEIGHT/2 # Updated DEFAULTSCREENHEIGHT
  @sprites["bg"].x=Settings::SCREEN_WIDTH/2  # Updated DEFAULTSCREENWIDTH
  @sprites["bg"].zoom_y=0
  @sprites["bg"].zoom_x=0
  @sprites["bg"].opacity=0
  @sprites["item"] = Sprite.new
  # (Settings::SCREEN_WIDTH/2,Settings::SCREEN_HEIGHT/2,@viewport) 
  # # Updated DEFAULTSCREENHEIGHT and DEFAULTSCREENWIDTH
  # species_keys = GameData::Species.keys
  #   # card = species_keys.sample
  #   card_data = GameData::Species.get(card)
    # card = card_data.id   # Make sure it's a symbol
    triadBitmap = TriadCard.new(@card).createModifiedBitmap(1)

    @sprites["item"].x = (Graphics.width / 2) 
    @sprites["item"].y = (Graphics.height / 2)
    @sprites["item"].z = 99999
  @sprites["item"].bitmap = triadBitmap

  #  @sprites["item"].setBitmap(TriadCard.new(cards[i]).createModifiedBitmap(2))
  @sprites["item"].ox=@sprites["item"].bitmap.width/2
  @sprites["item"].oy=@sprites["item"].bitmap.height/2
  @sprites["item"].angle=180
  @sprites["item"].zoom_y=0
  @sprites["item"].zoom_x=0
  @sprites["item"].opacity=0
    
  end

  



  
  def pbEndScene
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end

  def shakeItem
    3.times do
    Graphics.update
    @sprites["item"].angle+=2
    end
    3.times do
    Graphics.update
    @sprites["item"].angle-=2
    end
    3.times do
    Graphics.update
    @sprites["item"].angle-=2
    end
    3.times do
    Graphics.update
    @sprites["item"].angle+=2
    end
  end

  def pbUpdate
    pbWait(1)
    10.times do
    Graphics.update
    @sprites["whitescreen"].opacity+=255/10
    end
    10.times do
    Graphics.update
    @sprites["whitescreen"].opacity-=255/10
  end
    frametome=0
    18.times do
    frametome+=1
    Graphics.update
    @sprites["item"].angle-=15/2 if @sprites["item"].angle!=0
    @sprites["item"].angle=0 if @sprites["item"].angle<0
    pbMEPlay("Key item get") if frametome==7  # Updated ME to Essentials Default
    @sprites["bg"].zoom_y+=0.1/2 if @sprites["bg"].zoom_y<1.75
    @sprites["bg"].zoom_x+=0.1/2 if @sprites["bg"].zoom_x<1.75
    @sprites["bg"].opacity+=14.16
    @sprites["item"].zoom_y+=0.34/2 
    @sprites["item"].zoom_x+=0.34/2 
    @sprites["item"].opacity+=14.16
    end
    12.times do
    Graphics.update
    @sprites["item"].angle-=15/2 if @sprites["item"].angle!=0
    @sprites["item"].angle=0 if @sprites["item"].angle<0
    
    @sprites["bg"].zoom_y+=0.1/2 if @sprites["bg"].zoom_y>1
    @sprites["bg"].zoom_x+=0.1/2 if @sprites["bg"].zoom_x>1
    @sprites["bg"].zoom_x=1 if @sprites["bg"].zoom_x<1
    @sprites["bg"].zoom_y=1 if @sprites["bg"].zoom_y<1
    
    @sprites["item"].zoom_y-=0.17/2 if @sprites["item"].zoom_y>2
    @sprites["item"].zoom_x-=0.17/2 if @sprites["item"].zoom_x>2
    @sprites["item"].zoom_x=1 if @sprites["item"].zoom_x<2
    @sprites["item"].zoom_y=1 if @sprites["item"].zoom_y<2
    end
    @sprites["item"].angle=0
    @sprites["item"].zoom_y=2
    @sprites["item"].zoom_x=2
    @sprites["bg"].zoom_y=1
    @sprites["bg"].zoom_x=1
    shakeItem
    shakeItem
    pbWait(60)
    18.times do
    Graphics.update  
    @sprites["bg"].zoom_y-=0.15/2 
    @sprites["bg"].zoom_x+=0.1/2 
    @sprites["bg"].opacity-=14.16
    @sprites["item"].zoom_y-=0.34/2 
    @sprites["item"].zoom_x-=0.34/2 
    @sprites["item"].opacity-=14.16
    end
    pbGiveTriadCard(@card, @quantity)
    speciesname =  TriadCard.new(@card).name
    pbMessage(_INTL("\\You obtained a \\c[1] {1} card!\\wtnp[30]", speciesname))
    pbMessage(_INTL("You put the {1} Card in your Binder.", speciesname))
    loop do
      break
    end
  end
end
###################################################

class ReceiveCard

  def initialize(scene)
  @scene=scene
  end

  def pbStartScreen
  @scene.pbStartScene
  @scene.pbUpdate
  @scene.pbEndScene
  end

end

def pbGiveTriadCardWithAnimation(item,quantity=1)
  scene=ReceiveCardScene.new(item,quantity)
  screen=ReceiveCard.new(scene)
  screen.pbStartScreen
end