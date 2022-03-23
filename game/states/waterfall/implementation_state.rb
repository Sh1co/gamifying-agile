require 'gosu'
require 'gosu_texture_packer'
require_relative '../../constants'
require_relative 'waterfall_state'
require_relative 'testing_state'
require_relative '../../entities/customer'
require_relative '../../entities/action'
require_relative '../../entities/util_classes/solid_object'

class ImplementationState < WaterfallState
  CUSTOMER_FILE = Utils.media_path('customer.json')
  CAULDRON_WITH_WATER_FILE = Utils.media_path('pot_water.png')
  PORTAL_FILE = Utils.media_path('portal.png')
  ACTION_FILE = Utils.media_path('action1.png')
  CAULDRON_WITH_POTION_FILE = Utils.media_path('pot_potion.png')

  def initialize(order, tasks)
    super()
    @locations = Array[]
    customer_image = Gosu::TexturePacker.load_json(CUSTOMER_FILE, :precise)
    action_image = Gosu::Image.new($window, ACTION_FILE, false)
    customers = [
      Customer.new($window, 1200, 500, customer_image.frame('customer.png'), nil),
      Customer.new($window, 1200, 700, customer_image.frame('customer.png'), nil),
      Customer.new($window, 1200, 900, customer_image.frame('customer.png'), nil)
    ]
    portals = [
      Portal.new($window, Gosu::Image.new($window, PORTAL_FILE, false), 1500, 300, 1)
    ]
    cauldron = Cauldron.new(500, 500, Gosu::Image.new($window, CAULDRON_WITH_WATER_FILE, false))
    @locations.push(VillageLocation.new customers, cauldron, portals)
    @locations.push(SwampLocation.new [Portal.new($window, Gosu::Image.new($window, PORTAL_FILE, false), 300, 300, 0)], [
      CollectableIngredient.new(tasks[0], 2000, 500)
    ])
    @location = @locations[0]
    @order = order
    @features_to_implement = tasks
    @implemented_features = []
    @collected_ingredients = []
    @cooked_ingredients = []
    @actions = [Action.new($window, action_image, 2)]
    @selected_action = nil
    @dragged_object = nil
    @next_states = TestingState
  end

  def update
    @location.update_hero_position($window, @camera)

    if defined? @location.active_actions
      @location.active_actions.each  do |action|
        action.update
      end
    end

    unless @location.anomalies.length > 0
      @location.portals.each do |portal|
        if @location.hero.right_border > portal.x - 5 &&
          @location.hero.left_border  < portal.x + 5 &&
          @location.hero.bottom_border > portal.y - 5 &&
          @location.hero.top_border < portal.y + 5
          next_loc = @locations[portal.to_idx]
          prev_loc = @location
          next_loc.on_enter
          @location = next_loc
          prev_loc.on_leave
          return
        end
      end
    end

    if @location.anomalies.length > 0
      @location.anomalies.each do |anomaly|
        if anomaly.difficulty == 0
          @location.anomalies.delete_if { |el| el === anomaly }
        end
        @location.active_actions.each  do |action|
          unless SolidObject.will_not_collide? action, anomaly, action.x, action.y
            anomaly.difficulty -= action.action.strength
            @location.active_actions.delete_if { |el| el === action }
          end
        end
      end
    end

    if defined? @location.collectable_ingredients
      @location.collectable_ingredients.each do |ingredient|
        if @location.hero.right_border > ingredient.x - 5 &&
          @location.hero.left_border < ingredient.x + 5 &&
          @location.hero.bottom_border > ingredient.y - 5 &&
          @location.hero.top_border < ingredient.y + 5
          @collected_ingredients.push CollectedIngredient.new(ingredient.ingredient, 25, 310 + 10 * (@collected_ingredients.length - 1))
          @location.collectable_ingredients.delete_if { |el| el === ingredient }
        end
      end
    end

    unless @dragged_object.nil?
      @dragged_object.x = $window.mouse_x
      @dragged_object.y = $window.mouse_y
    end
  end

  def button_down(id)
    if id == Gosu::MsLeft
      if @location.mode == :battle && !@selected_action.nil?
        @location.active_actions.push(ActiveAction.new $window, @camera, @selected_action, @location.hero.x, @location.hero.y)
      end
      @collected_ingredients.each do |el|
        if el.is_hovered?($window.mouse_x, $window.mouse_y)
          @dragged_object = el
        end
      end
      @actions.each do |el|
        if el.is_hovered?($window.mouse_x, $window.mouse_y)
          el.is_selected = true
          @selected_action = el
        end
      end
    end
  end

  def button_up(id)
    if id == Gosu::MsLeft && !@dragged_object.nil? && defined? @location.cauldron
      if @location.cauldron.is_hovered?($window.mouse_x, $window.mouse_y, @camera)
        if @location.cauldron.ingredients.length == 0
          @location.cauldron.image = Gosu::Image.new($window, CAULDRON_WITH_POTION_FILE, false)
        end
        @location.cauldron.ingredients.push(@dragged_object.ingredient)
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
    @location.draw($window, @camera)
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
    $window.draw_quad(
      WINDOW_WIDTH - 100, 300, color,
      WINDOW_WIDTH, 300, color,
      WINDOW_WIDTH, 920, color,
      WINDOW_WIDTH - 100, 920, color,
      200)

    @collected_ingredients.each do |el|
      el.draw
    end
    @actions.each_with_index do |el, idx|
      el.x = WINDOW_WIDTH - 50
      el.y = 350 + idx*20
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
