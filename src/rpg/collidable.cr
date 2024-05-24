module RPG
  abstract class Collidable
    getter x : Int32 | Float32
    getter y : Int32 | Float32
    getter? area_triggered
    getter dialog_key : String

    Size = 64

    def initialize(@x = 0, @y = 0, @dialog_key = "")
      @area_triggered = false
    end

    def size
      Size
    end

    def collision_width
      size
    end

    def collision_height
      size / 2
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

    def check_area_triggered?(player : Player)
      dx = x - player.x
      dy = y - player.y
      distance = Math.sqrt(dx ** 2 + dy ** 2)

      @area_triggered = true if distance <= area_radius && player.facing?(x, y)
      @area_triggered
    end

    def jump(x, y)
      @x = x
      @y = y
    end

    def jump_to_tile(col, row, tile_size)
      jump(
        col * tile_size + (tile_size / 2).to_f32,
        row * tile_size + (tile_size / 2).to_f32
      )
    end

    def update(frame_time)
      reset_area_triggered
    end

    def draw(window : SF::RenderWindow)
    end
  end
end
