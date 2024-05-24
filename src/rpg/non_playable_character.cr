module RPG
  class NonPlayableCharacter < Character
    getter? area_triggered
    getter dialog_key : String

    def initialize(x = 0, y = 0, @dialog_key = "")
      super(x, y)

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
  end
end
