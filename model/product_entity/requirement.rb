require_relative './product_entity'

class Requirement < ProductEntity
  attr_reader :name,
              :complexity,
              :software_components

  def initialize(name, software_components)
    @name = name
    @complexity = software_components.length
    @software_components = software_components
  end
end
