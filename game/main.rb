class Pipes
  # @abstract
  @instance = new

  def self.instance
    @instance
  end
end

class Color
  include Ruby::Enum

  # just example values
  define :RED, 'red'
  define :GREEN, 'green'
  define :YELLOW, 'yellow'
  define :MAGENTA, 'magenta'
  define :BLUE, 'blue'
end

class Crystal
  @color 

  def initialize(col)
    @color = col
  end
end

class Potion
  # @abstract
  # We are still not sure about it's place in the flow
end

class GameState
  # @abstract
  @instance = new
  @actions = []
  @environment
  @product

  def self.instance
    @instance
  end

  def initialize(anom, act, env, prod)
    @anomalies = anom
    @actions = act
    @environment = env
    @product = prod
  end
end