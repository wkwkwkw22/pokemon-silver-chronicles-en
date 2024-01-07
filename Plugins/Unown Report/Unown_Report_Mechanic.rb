class UnownreportButton < SpriteWrapper
	attr_reader :index
	attr_reader :name
	attr_accessor :selected
	
	def initialize(x,y,name="",index=0,viewport=nil)
		super(viewport)
		@index=index
		@name=name
		@selected=false
		
		@button=AnimatedBitmap.new("Graphics/Pictures/UnownReport/unownreportButton") 	
		@contents=BitmapWrapper.new(@button.width,@button.height)
		self.bitmap=@contents
		self.x=x
		self.y=y
		refresh
		update
	end
	
	def dispose
		@button.dispose
		@contents.dispose
		super
	end
	
	def refresh
		self.bitmap.clear
		self.bitmap.blt(0,0,@button.bitmap,Rect.new(0,0,@button.width,@button.height))
		pbSetSystemFont(self.bitmap)
		textpos=[ # Name is written on both unselected and selected buttons
			[@name,self.bitmap.width/2,10,2,Color.new(248,248,248),Color.new(40,40,40)],
			[@name,self.bitmap.width/2,62,2,Color.new(248,248,248),Color.new(40,40,40)]
		]
		pbDrawTextPositions(self.bitmap,textpos)
    iconName=@name
    iconName="1" if iconName==_INTL("?????")
    iconName="2" if iconName==_INTL("!!!!!")
		icon=sprintf("Graphics/Pictures/UnownReport/unownreport"+iconName)
		imagepos=[ # Icon is put on both unselected and selected buttons
			[icon,18,10,0,0,-1,-1],
			[icon,18,62,0,0,-1,-1]
		]
		pbDrawImagePositions(self.bitmap,imagepos)
	end
	
	def update
		if self.selected
			self.src_rect.set(0,self.bitmap.height/2,self.bitmap.width,self.bitmap.height/2)
    else
			self.src_rect.set(0,0,self.bitmap.width,self.bitmap.height/2)
		end
		super
	end
end



#===============================================================================
# - Scene_Unownreport
#-------------------------------------------------------------------------------
# Modified By Richard PT
#===============================================================================
class Scene_Unownreport

	def seen_unown_form_any_gender?(form)
		ret = false
		if $player.pokedex.caught_form?(:UNOWN, 0, form) ||
		  $player.pokedex.caught_form?(:UNOWN, 1, form)
		  ret = true
		end
		return ret
	end
	
	#-----------------------------------------------------------------------------
	# initialize
	#-----------------------------------------------------------------------------
	def initialize(menu_index = 0)
		@menu_index = menu_index
	end
	#-----------------------------------------------------------------------------
	# main
	#-----------------------------------------------------------------------------
	def main
		commands=[]
		# OPTIONS - If you change these, you should also change update_command below.
		@cmdAnger=-1
		@cmdBear=-1
		@cmdChase=-1
		@cmdDirect=-1
		@cmdEngage=-1
		@cmdFind=-1
		@cmdGive=-1
		@cmdHelp=-1
		@cmdIncrease=-1
		@cmdJoin=-1
		@cmdKeep=-1
		@cmdLaugh=-1
		@cmdMake=-1
		@cmdNuzzle=-1
		@cmdObserve=-1
		@cmdPerform=-1
		@cmdQuicken=-1
		@cmdReassure=-1
		@cmdSearch=-1
		@cmdTell=-1
		@cmdUndo=-1
		@cmdVanish=-1
		@cmdWant=-1
		@cmdXXXXX=-1
		@cmdYield=-1
		@cmdZoom=-1
		@cmd1=-1
		@cmd2=-1
		
		commands[@cmdAnger=commands.length]=_INTL("Anger") if seen_unown_form_any_gender?(0)
		commands[@cmdBear=commands.length]=_INTL("Bear")  if seen_unown_form_any_gender?(1)
		commands[@cmdChase=commands.length]=_INTL("Chase")  if seen_unown_form_any_gender?(2)
		commands[@cmdDirect=commands.length]=_INTL("Direct")  if seen_unown_form_any_gender?(3)
		commands[@cmdEngage=commands.length]=_INTL("Engage")  if seen_unown_form_any_gender?(4)
		commands[@cmdFind=commands.length]=_INTL("Find")  if seen_unown_form_any_gender?(5)
		commands[@cmdGive=commands.length]=_INTL("Give")  if seen_unown_form_any_gender?(6)
		commands[@cmdHelp=commands.length]=_INTL("Help")  if seen_unown_form_any_gender?(7)
		commands[@cmdIncrease=commands.length]=_INTL("Increase")  if seen_unown_form_any_gender?(8)
		commands[@cmdJoin=commands.length]=_INTL("Join")  if seen_unown_form_any_gender?(9)
		commands[@cmdKeep=commands.length]=_INTL("Keep")  if seen_unown_form_any_gender?(10)
		commands[@cmdLaugh=commands.length]=_INTL("Laugh")  if seen_unown_form_any_gender?(11)
		commands[@cmdMake=commands.length]=_INTL("Make")  if seen_unown_form_any_gender?(12)
		commands[@cmdNuzzle=commands.length]=_INTL("Nuzzle")  if seen_unown_form_any_gender?(13)
		commands[@cmdObserve=commands.length]=_INTL("Observe")  if seen_unown_form_any_gender?(14)
		commands[@cmdPerform=commands.length]=_INTL("Perform")  if seen_unown_form_any_gender?(15)
		commands[@cmdQuicken=commands.length]=_INTL("Quicken")  if seen_unown_form_any_gender?(16)
		commands[@cmdReassure=commands.length]=_INTL("Reassure")  if seen_unown_form_any_gender?(17)
		commands[@cmdSearch=commands.length]=_INTL("Search")  if seen_unown_form_any_gender?(18)
		commands[@cmdTell=commands.length]=_INTL("Tell")  if seen_unown_form_any_gender?(19)
		commands[@cmdUndo=commands.length]=_INTL("Undo")  if seen_unown_form_any_gender?(20)
		commands[@cmdVanish=commands.length]=_INTL("Vanish")  if seen_unown_form_any_gender?(21)
		commands[@cmdWant=commands.length]=_INTL("Want")  if seen_unown_form_any_gender?(22)
		commands[@cmdXXXXX=commands.length]=_INTL("XXXXX")  if seen_unown_form_any_gender?(23)
		commands[@cmdYield=commands.length]=_INTL("Yield")  if seen_unown_form_any_gender?(24)
		commands[@cmdZoom=commands.length]=_INTL("Zoom")  if seen_unown_form_any_gender?(25)
		commands[@cmd1=commands.length]=_INTL("?????")  if seen_unown_form_any_gender?(26)
		commands[@cmd2=commands.length]=_INTL("!!!!!")  if seen_unown_form_any_gender?(27)
		
		@viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
		@viewport.z=99999
    borderSize=80
    viewport2=Viewport.new(0,borderSize,Graphics.width,Graphics.height-borderSize*4)
    viewport2.z=99999
		@button=AnimatedBitmap.new("Graphics/Pictures/UnownReport/unownreportButton")
		@sprites={}
		@sprites["background"] = IconSprite.new(0,0)
		femback=pbResolveBitmap(sprintf("Graphics/Pictures/UnownReport/unownreportbgf"))
		if $Trainer.gender==1 && femback
			@sprites["background"].setBitmap("Graphics/Pictures/UnownReport/unownreportbgf")
			else
			@sprites["background"].setBitmap("Graphics/Pictures/UnownReport/unownreportbg")
		end
		@sprites["command_window"] = Window_CommandPokemon.new(commands,160)
		@sprites["command_window"].visible = false
    @sprites["command_window"].index = @menu_index
    for i in 0...commands.length
      @sprites["button#{i}"]=UnownreportButton.new(42,0,commands[i],i,@viewport)
      @sprites["button#{i}"].visible = false
      @sprites["button#{i}"].update
    end
		Graphics.transition
		loop do
			Graphics.update
			Input.update
			update
			if $scene != self
				break
			end
		end
		Graphics.freeze
		pbDisposeSpriteHash(@sprites)
	end
	#-----------------------------------------------------------------------------
	# update the scene
	#-----------------------------------------------------------------------------
	def update
    windowsLength = @sprites["command_window"].commands.length
    optionsSize = 2 # Number of lines above mid
		for i in 0...windowsLength
			sprite=@sprites["button#{i}"]
      windowsIndex = @sprites["command_window"].index
      screenIndex = i-windowsIndex+optionsSize+1
      screenIndex+=windowsIndex-optionsSize if windowsIndex<optionsSize
      if windowsLength-windowsIndex<=optionsSize
        screenIndex+=1+optionsSize-(windowsLength-windowsIndex)
      end
      visible = 0<screenIndex && screenIndex<(optionsSize+1)*2
      sprite.y=24 + (screenIndex*48) if visible
      sprite.visible = visible
			sprite.selected= i==windowsIndex
		end
		pbUpdateSpriteHash(@sprites)
		#update command window and the info if it's active
		if @sprites["command_window"].active
			update_command
			return
		end
	end
	#-----------------------------------------------------------------------------
	# update the command window
	#-----------------------------------------------------------------------------
	def update_command
		if Input.trigger?(Input::B)
      pbPlayCancelSE()
      $scene = Scene_Map.new
			return
		end
		if Input.trigger?(Input::C)
			if @cmdAnger>=0 && @sprites["command_window"].index==@cmdAnger
			end
			return
		end
	end
end