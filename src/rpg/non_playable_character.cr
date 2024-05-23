module RPG
  class NonPlayableCharacter < Character
    getter? area_triggered

    Debug = true

    def initialize(x = 0, y = 0)
      super

      @area_triggered = false
    end

    def area_radius
      {size * 2, size * 2}
    end

    def update(frame_time)
      super

      # check if area triggered?
    end

    def draw(window : SF::RenderWindow)
      draw_area(window) if Debug

      super
    end

    def draw_area(window)
      ellipse = GSF::EllipseShape.new(area_radius)
      ellipse.fill_color = SF::Color::Red
      ellipse.outline_color = SF::Color::Red
      ellipse.outline_thickness = 2
      ellipse.origin = {area_radius[0], area_radius[1]}
      ellipse.position = {x, y}

      window.draw(ellipse)
    end
  end
end
