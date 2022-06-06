require_relative 'waterfall_state'
require_relative 'implementation_state'
require_relative '../../entities/recipe_book'

class DesignState < WaterfallState
  CUSTOMER_FILE = Utils.media_path('customer.json')
  PORTAL_FILE = Utils.media_path('portal.png')
  EMPTY_CAULDRON_FILE = Utils.media_path('pot.png')

  def initialize(order, tasks)
    super()
    customer_image = Gosu::TexturePacker.load_json(CUSTOMER_FILE, :precise)
    customers = [Customer.new($window, 1200, 500, Gosu::Image.new($window, Utils.media_path('customer1.png'), false), nil),
                 Customer.new($window, 1200, 700, Gosu::Image.new($window, Utils.media_path('customer2.png'), false), nil),
                 Customer.new($window, 1200, 900, Gosu::Image.new($window, Utils.media_path('customer3.png'), false), nil),
                 Customer.new($window, 1000, 300, Gosu::Image.new($window, Utils.media_path('customer3.png'), false), nil),
                 Customer.new($window, 700, 300, Gosu::Image.new($window, Utils.media_path('customer2.png'), false), nil),
                 Customer.new($window, 1400, 900, Gosu::Image.new($window, Utils.media_path('customer4.png'), false), nil),
                 Customer.new($window, 1400, 700, Gosu::Image.new($window, Utils.media_path('customer5.png'), false), nil),
                 Customer.new($window, 1400, 500, Gosu::Image.new($window, Utils.media_path('customer6.png'), false), nil),
                 Customer.new($window, 700, 900, Gosu::Image.new($window, Utils.media_path('customer7.png'), false), nil),
                 Customer.new($window, 500, 900, Gosu::Image.new($window, Utils.media_path('customer4.png'), false), nil),
                 Customer.new($window, 300, 900, Gosu::Image.new($window, Utils.media_path('customer2.png'), false), nil),
                 Customer.new($window, 300, 500, Gosu::Image.new($window, Utils.media_path('customer4.png'), false), nil),
                 Customer.new($window, 500, 100, Gosu::Image.new($window, Utils.media_path('customer1.png'), false), nil),
                 Customer.new($window, 500, 300, Gosu::Image.new($window, Utils.media_path('customer3.png'), false), nil),
                 Customer.new($window, 300, 100, Gosu::Image.new($window, Utils.media_path('customer2.png'), false), nil),
                 Customer.new($window, 300, 300, Gosu::Image.new($window, Utils.media_path('customer7.png'), false), nil),
                 Customer.new($window, 300, 700, Gosu::Image.new($window, Utils.media_path('customer6.png'), false), nil),
                 Customer.new($window, 700, 100, Gosu::Image.new($window, Utils.media_path('customer6.png'), false), nil),
                 Customer.new($window, 900, 100, Gosu::Image.new($window, Utils.media_path('customer4.png'), false), nil),
                 Customer.new($window, 1100, 100, Gosu::Image.new($window, Utils.media_path('customer1.png'), false), nil),
                 Customer.new($window, 1300, 100, Gosu::Image.new($window, Utils.media_path('customer5.png'), false), nil),
                 Customer.new($window, 1300, 300, Gosu::Image.new($window, Utils.media_path('customer2.png'), false), nil),
                 Customer.new($window, 1500, 200, Gosu::Image.new($window, Utils.media_path('customer7.png'), false), nil),
    ]
    portals = [
      Portal.new($window, Gosu::Image.new($window, PORTAL_FILE, false), 1500, 300, nil)
    ]
    cauldron = Cauldron.new(500, 500, Gosu::Image.new($window, EMPTY_CAULDRON_FILE, false))
    @location = VillageLocation.new customers, cauldron, portals
    @features_to_design = tasks
    @budget = order.budget
    @designed_features = []
    @recipe_book_open = false
    @book = RecipeBook.new $window
    @next_states = ImplementationState
  end

  def button_down(id)
    if id == Gosu::MsLeft
      unless @recipe_book_open
        if $window.mouse_x > 10 && $window.mouse_x < 60 && $window.mouse_y > 10 && $window.mouse_y < 60
          @recipe_book_open = true
        end
      end
      if @recipe_book_open
        if $window.mouse_x > WINDOW_WIDTH/2 - 220 && $window.mouse_x < WINDOW_WIDTH/2 - 70 && $window.mouse_y > 790 && $window.mouse_y < 840
          ingredient = @book.ingredients[0]
          @budget = @budget - ingredient.cost
          @designed_features.push(ingredient)
          ingredient.features.each do |feature|
            index = @features_to_design.index(@features_to_design.find {|f| f.name == feature.name})
            @features_to_design.delete_at index
          end
        elsif $window.mouse_x < WINDOW_WIDTH/2 + 220 && $window.mouse_x > WINDOW_WIDTH/2 + 70 && $window.mouse_y > 790 && $window.mouse_y < 840
          ingredient = @book.ingredients[1]
          @budget = @budget - ingredient.cost
          @designed_features.push(ingredient)
          ingredient.features.each do |feature|
            index = @features_to_design.index(@features_to_design.find {|f| f.name == feature.name})
            @features_to_design.delete_at index
          end
        elsif $window.mouse_x > 1300 || $window.mouse_x < 600 && $window.mouse_y > 900 && $window.mouse_y < 100
          @recipe_book_open = false
          if @features_to_design.length == 0
            GameState.switch_state(@next_states.new @order, @designed_features)
          end
        end
      end
    end
  end

  def update
    unless @recipe_book_open
      @location.update_hero_position($window, @camera)
    end
  end

  def draw
    @location.draw($window, @camera)
    unless @recipe_book_open
      color = Gosu::Color.new(255, 147, 91, 5)
      icon = Gosu::Image.new(
        $window, Utils.media_path('yellow_icon.png'), false)
      $window.draw_quad(
        300, 920, color,
        1620, 920, color,
        1620, 1080, color,
        300, 1080, color,
        200)
      @features_to_design.each_with_index do |feature, idx|
        icon.draw(300 + 170*idx, 930, 201)
        feature.big_image.draw(300 + 170*idx, 930, 202)
      end
      @designed_features.each_with_index do |feature, idx|
        feature.draw_task(300 + 10*(idx + @features_to_design.length), 930)
      end
      color = Gosu::Color.new(100, 0, 0, 0)
      $window.draw_quad(
        0, 0, color,
        1920, 0, color,
        1920, 80, color,
        0, 80, color,
        200)
      book_icon = Gosu::Image.new(
        $window, Utils.media_path('book_icon.png'), false)
      book_icon.draw(10, 10, 201)
    end
    if @recipe_book_open
      @book.draw
      Gosu::Image.from_text(
        $window, "Budget left: #{@budget}",
        Gosu.default_font_name, 50).draw(1050, 100, 301)
    end
  end
end
