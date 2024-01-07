#===============================================================================
#  Main Utility Module for Elite Battle: DX
#-------------------------------------------------------------------------------
#  used to store and manipulate all of the configurable data and much more
#===============================================================================
module MyUI
  # variables for storing system data
  @vectors = {}
  @nextVectors = []
  # slight transition gimmick
  @tviewport = nil
  

 
  #-----------------------------------------------------------------------------
  # stores vector data
  #-----------------------------------------------------------------------------
  def self.add_vector(key,*args)
    if key == :CAMERA
      @vectors[key] = []
      for v in args
        v.push(1); @vectors[key].push(v)
      end
      return
    end
    args.push(1)
    @vectors[key] = args
  end
  #-----------------------------------------------------------------------------
  # returns vector data
  #-----------------------------------------------------------------------------
  def self.get_vector(key, cond = nil)
    Console.echo_li "Arrived on get_vector #{key}"

    # if [:MAIN, :BATTLER].include?(key)
    #   case key
    #   when :MAIN
    #     return @vectors[:TRIPLE].clone if @vectors.has_key?(:TRIPLE) && cond.respond_to?(:triplebattle?) && cond.triplebattle?
    #     return @vectors[:DOUBLE].clone if @vectors.has_key?(:DOUBLE) && cond.respond_to?(:doublebattle?) && cond.doublebattle?
    #     return @vectors[:SINGLE].clone if @vectors.has_key?(:SINGLE)
    #   when :BATTLER
    #     return cond ? @vectors[:PLAYER].clone : @vectors[:ENEMY].clone if @vectors.has_key?(:PLAYER, :ENEMY)
    #   end
    # end

    if @vectors.has_key?(:PLAYER)
      Console.echo_li "Arrived on has key :PLAYER"
      return @vectors[:PLAYER].clone
    end

    #ORDER IS X,Y,SCALE,ANGLE - Don't know the last one yet I think it's Z-index
    return [102, 408, 32, 342, 1, 1] if !@vectors.has_key?(key)

    Console.echo_li "ARRIVED ON FINAL RETURN"

    return @vectors[key].clone
  end
  #-----------------------------------------------------------------------------
  #  store random motion vectors
  #-----------------------------------------------------------------------------
  def self.next_vector(*args)
    for vec in args
      @nextVectors.push(vec) if vec.is_a?(Array) && vec.length > 5
    end
  end
  #-----------------------------------------------------------------------------
  # gets random camera vector motion
  #-----------------------------------------------------------------------------
  def self.random_vector(battle, last)
    # failsafe
    if !@vectors.keys.include?(:CAMERA_MOTION) || !@vectors[:CAMERA_MOTION].is_a?(Array) || @vectors[:CAMERA_MOTION].empty?
      return self.get_vector(:MAIN, battle).clone
    end
    a = @nextVectors.length > 0 ? @nextVectors.clone : @vectors[:CAMERA_MOTION].clone
    a.push(self.get_vector(:MAIN, battle))
    a.delete_at(last) if !last.nil?
    return a
  end
  #-----------------------------------------------------------------------------



    #-----------------------------------------------------------------------------
  # internally parses action to valid symbolic name
  #-----------------------------------------------------------------------------
  def self.parse(var)
    return nil if !var.is_a?(Symbol) && !var.is_a?(String)
    return var if eval("defined?(@#{var})")
    return nil
  end
    #-----------------------------------------------------------------------------
  # gets value of specified varaible
  #-----------------------------------------------------------------------------
  def self.get(var)
    var = self.parse(var)
    return nil if var.nil?
    return self.instance_variable_get("@#{var}")
  end
end

MyUI.add_vector(:CAMERA_MOTION,
  [132, 408, 24, 302, 1],
  [122, 294, 20, 322, 1],
  [238, 304, 26, 322, 1],
  [0, 384, 26, 322, 1],
  [198, 298, 18, 282, 1],
  [196, 306, 26, 242, 0.6],
  [156, 280, 18, 226, 0.6],
  [60, 280, 12, 388, 1],
  [160, 286, 16, 340, 1]
)

#-------------------------------------------------------------------------------
# failsafe
module EnvironmentEBDX; end
module TerrainEBDX; end
module BattleScripts; end
