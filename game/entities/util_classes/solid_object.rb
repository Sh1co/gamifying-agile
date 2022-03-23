require_relative 'interactive'

class SolidObject < Interactive
  def self.will_not_collide?(hero, obj, new_x, new_y)
    (new_x + hero.width/2 < obj.left_border && new_x - hero.width/2 < obj.left_border) ||
      (new_x + hero.width/2 > obj.right_border && new_x - hero.width/2 > obj.right_border) ||
      (new_y + hero.height/2 > obj.bottom_border && new_y - hero.height/2 > obj.bottom_border) ||
      (new_y + hero.height/2 < obj.top_border && new_y - hero.height/2 < obj.top_border)
  end
end
