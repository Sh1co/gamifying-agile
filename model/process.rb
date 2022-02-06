require_relative 'actions.rb'
require_relative 'anomalies.rb'

class Environment
  # @abstract
  @instance = new

  def self.instance
    @instance
  end
end

class Product
  # @abstract
  # We are still not sure about it's place in the flow
end

class Skill
  include Ruby::Enum

  # just example values
  define :FRONTEND, 'frontend'
  define :BACKEND, 'backend'
  define :DEVOPS, 'devops'
end

class TeamMember
  # @abstract
  @skill = nil

  def initialize(sk)
    @skill = sk
  end
end

class ProcessState
  # @abstract
  @instance = new
  @anomalies = []
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