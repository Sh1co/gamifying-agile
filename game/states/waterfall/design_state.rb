require_relative 'waterfall_state'
require_relative 'implementation_state'
require_relative '../../entities/recipe_book'

class DesignState < WaterfallState
  def initialize(order, tasks)
    super()
    @customers = [
      Customer.new($window, 1200, 500, @customer_image.frame('customer.png'), nil),
      Customer.new($window, 1200, 700, @customer_image.frame('customer.png'), nil),
      Customer.new($window, 1200, 900, @customer_image.frame('customer.png'), nil)
    ]
    @features_to_design = tasks
    @budget = order.budget
    @designed_features = []
    @recipe_book_open = false
    @book = RecipeBook.new $window
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
        elsif $window.mouse_x > 1300 || $window.mouse_x < 600 && $window.mouse_y > 900 && $window.mouse_y < 100
          @recipe_book_open = false
          if @features_to_design.length == 0
            GameState.switch(ImplementationState.new @order, @designed_features)
          end
        end
      end
    end
  end

  def update
    unless @recipe_book_open
      if $window.button_down?(Gosu::KbA) && can_move_to?(@hero, @hero.x - SPEED, @hero.y)
        if @camera.x > WINDOW_WIDTH / 2 && @hero.x < (MAP_WIDTH - WINDOW_WIDTH / 2)
          @camera.x -= SPEED
        end
        @hero.x -= SPEED
        @hero.w_x = @hero.x - (@camera.x - WINDOW_WIDTH / 2)
      end

      if $window.button_down?(Gosu::KbD) && can_move_to?(@hero, @hero.x + SPEED, @hero.y)
        if @camera.x < (MAP_WIDTH - WINDOW_WIDTH / 2) && @hero.x > (WINDOW_WIDTH / 2)
          @camera.x += SPEED
        end
        @hero.x += SPEED
        @hero.w_x = @hero.x - (@camera.x - WINDOW_WIDTH / 2)
      end
      if $window.button_down?(Gosu::KbW) && can_move_to?(@hero, @hero.x, @hero.y - SPEED)
        if @camera.y > WINDOW_HEIGHT / 2 && @hero.y < (MAP_HEIGHT - WINDOW_HEIGHT / 2)
          @camera.y -= SPEED
        end
        @hero.y -= SPEED
        @hero.w_y = @hero.y - (@camera.y - WINDOW_HEIGHT / 2)
      end
      if $window.button_down?(Gosu::KbS) && can_move_to?(@hero, @hero.x, @hero.y + SPEED)
        if @camera.y < (MAP_HEIGHT - WINDOW_HEIGHT / 2) && @hero.y > (WINDOW_HEIGHT / 2)
          @camera.y += SPEED
        end
        @hero.y += SPEED
        @hero.w_y = @hero.y - (@camera.y - WINDOW_HEIGHT / 2)
      end
      @hero.update
    end
  end

  def draw
    off_x = -@camera.x + $window.width / 2
    off_y = -@camera.y + $window.height / 2
    $window.translate(off_x, off_y) do
      @background.draw(0, 0, 0)
      @hero.draw
      @customers.each { |customer| customer.draw }
    end
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
        icon.draw(300 + 10*idx, 930, 201)
        feature.big_image.draw(300 + 10*idx, 930, 202)
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
