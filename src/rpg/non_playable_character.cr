module RPG
  class NonPlayableCharacter < Character
    getter? area_triggered

    Debug = true

    def initialize(x = 0, y = 0)
      super

      @area_triggered = false
    end

    def action
      "talk"
    end

    def area_radius
      size * 2
    end

    def reset_area_triggered
      @area_triggered = false
    end

    def check_area_triggered(player : Player)
      dx = x - player.x
      dy = y - player.y
      distance = Math.sqrt(dx ** 2 + dy ** 2)

      @area_triggered = true if distance <= area_radius && player.facing?(x, y)
      @area_triggered
    end

    def update(frame_time)
      super

      reset_area_triggered
    end

    def draw(window : SF::RenderWindow)
      draw_area(window) if Debug

      super
    end

    def draw_area(window)
      circle = SF::CircleShape.new(area_radius)
      circle.fill_color = area_triggered? ? SF::Color::Transparent : SF::Color::Red
      circle.outline_color = SF::Color::Red
      circle.outline_thickness = 2
      circle.origin = {area_radius, area_radius}
      circle.position = {x, y}

      window.draw(circle)
    end
  end
end
