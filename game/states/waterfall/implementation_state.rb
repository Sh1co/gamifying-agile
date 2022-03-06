require 'gosu'
require 'gosu_texture_packer'
require_relative '../../constants'
require_relative 'waterfall_state'
require_relative 'testing_state'
require_relative '../../entities/ingredient'

class ImplementationState < WaterfallState
  CAULDRON_WITH_WATER_FILE = Utils.media_path('pot_water.png')
  CAULDRON_WITH_POTION_FILE = Utils.media_path('pot_potion.png')

  def initialize(order, tasks)
    super()
    @customers = [
      Customer.new($window, 1200, 500, @customer_image.frame('customer.png'), nil),
      Customer.new($window, 1200, 700, @customer_image.frame('customer.png'), nil),
      Customer.new($window, 1200, 900, @customer_image.frame('customer.png'), nil)
    ]
    @cauldron.image = Gosu::Image.new($window, CAULDRON_WITH_WATER_FILE, false)
    @collectable_ingredients = [
      CollectableIngredient.new(tasks[0], 2000, 500)
    ]
    @order = order
    @features_to_implement = tasks
    @implemented_features = []
    @collected_ingredients = []
    @cooked_ingredients = []
    @dragged_object = nil
    @next_state = TestingState
  end

  def update
    update_hero_position
    @collectable_ingredients.each do |ingredient|
      if @hero.x + @hero.width > ingredient.x - 5 && @hero.x < ingredient.x + 5 && @hero.y + @hero.height > ingredient.y - 5 && @hero.y < ingredient.y + 5
        @collected_ingredients.push CollectedIngredient.new(ingredient.ingredient, 25, 310+ 10*(@collected_ingredients.length - 1))
        @collectable_ingredients.delete_if { |el| el === ingredient }
      end
    end

    unless @dragged_object.nil?
      @dragged_object.x = $window.mouse_x
      @dragged_object.y = $window.mouse_y
    end
  end

  def button_down(id)
    if id == Gosu::MsLeft
      @collected_ingredients.each do |el|
        if $window.mouse_x > el.x && $window.mouse_x < el.x + 30 && $window.mouse_y > el.y && $window.mouse_y < el.y + 50
          @dragged_object = el
        end
      end
    end
  end

  def button_up(id)
    if id == Gosu::MsLeft && !@dragged_object.nil?
      if $window.mouse_x > @cauldron.x && $window.mouse_x < @cauldron.x + @cauldron.width && $window.mouse_y > @cauldron.y && $window.mouse_y < @cauldron.y + @cauldron.height
        if @cauldron.ingredients.length == 0
          @cauldron.image = Gosu::Image.new($window, CAULDRON_WITH_POTION_FILE, false)
        end
        @cauldron.ingredients.push(@dragged_object.ingredient)
        @features_to_implement.delete_if { |el| el === @dragged_object.ingredient }
        @implemented_features.concat @dragged_object.ingredient.features
        @collected_ingredients.delete_if { |el| el === @dragged_object }
        @dragged_object = nil
        # if @features_to_implement.length == 0
        #   GameState.switch(@next_state.new(@order, @implemented_features))
        # end
      else
        @dragged_object.x = @dragged_object.home_x
        @dragged_object.y = @dragged_object.home_y
      end
      @dragged_object = nil
    end
  end

  def draw
    off_x = -@camera.x + $window.width / 2
    off_y = -@camera.y + $window.height / 2
    $window.translate(off_x, off_y) do
      @background.draw(0, 0, 0)
      @hero.draw
      @customers.each { |customer| customer.draw }
      @collectable_ingredients.each { |ingredient| ingredient.draw }
      @cauldron.draw
    end
    color = Gosu::Color.new(255, 147, 91, 5)
    $window.draw_quad(
      300, 920, color,
      1620, 920, color,
      1620, 1080, color,
      300, 1080, color,
      200)

    color = Gosu::Color.new(100, 0, 0, 0)
    $window.draw_quad(
      0, 300, color,
      100, 300, color,
      100, 920, color,
      0, 920, color,
      200)

    @collected_ingredients.each do |el|
      el.draw
    end

    index = 0
    @features_to_implement.each_with_index do |feature, idx|
      index += idx
      feature.draw_task(300 + 10*(index), 930)
    end

    @implemented_features.each_with_index do |feature, idx|
      index += idx
      feature.draw_completed(300 + 10*(index), 930)
    end
  end
end
