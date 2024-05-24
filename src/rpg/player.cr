require "./character"
require "./direction"

module RPG
  class Player < Character
    getter dx : Int32 | Float32
    getter dy : Int32 | Float32
    getter direction : Direction

    def initialize(x = 0, y = 0)
      super

      @dx = 0
      @dy = 0
      @direction = Direction::Down
    end

    def update(frame_time, keys : Keys)
      update_movement(frame_time, keys)

      super(frame_time)
    end

    def update_movement(frame_time, keys : Keys)
      @dx = 0
      @dy = 0

      @dy -= 1 if keys.pressed?([Keys::W])
      @dx -= 1 if keys.pressed?([Keys::A])
      @dy += 1 if keys.pressed?([Keys::S])
      @dx += 1 if keys.pressed?([Keys::D])

      return if dx == 0 && dy == 0

      @dx, @dy = with_direction_and_speed(frame_time, dx, dy)
      move_with_level(dx, dy)

      return if dx == 0 && dy == 0

      change_direction(dx, dy)
      animate_move(dx, dy)
      move(dx, dy)
    end

    def with_direction_and_speed(frame_time, dx, dy)
      directional_speed = dx != 0 && dy != 0 ? Speed / 1.4142 : Speed
      dx *= (directional_speed * frame_time).to_f32
      dy *= (directional_speed * frame_time).to_f32

      {dx, dy}
    end

    def move_with_level(dx, dy)
      # screen collisions
      @dx = 0 if x + dx < 0 || x + dx > Screen.width
      @dy = 0 if y + dy < 0 || y + dy > Screen.height
    end

    def change_direction(dx, dy)
      if dx.abs > 0 && dy.abs > 0
        if dy < 0
          @direction = dx > 0 ? Direction::UpRight : Direction::UpLeft
        else
          @direction = dx > 0 ? Direction::DownRight : Direction::DownLeft
        end
      elsif dy.abs > 0
        @direction = dy < 0 ? Direction::Up : Direction::Down
      elsif dx.abs > 0
        @direction = dx > 0 ? Direction::Right : Direction::Left
      end
    end

    def facing?(other_x, other_y)
      if x > other_x
        if y > other_y
          direction.left_or_up?
        elsif y < other_y
          direction.left_or_down?
        else
          direction.left_any?
        end
      elsif x < other_x
        if y > other_y
          direction.right_or_up?
        elsif y < other_y
          direction.right_or_down?
        else
          direction.right_any?
        end
      else
        if y > other_y
          direction.up_any?
        elsif y < other_y
          direction.down_any?
        else
          true
        end
      end
    end

    def collision(char : Character) : Tuple(Bool, Bool)
      x = @x - dx
      y = @y - dy

      collides_x = x + dx - collision_width / 2 < char.x + char.collision_width / 2 &&
        x + dx + collision_width / 2 > char.x - char.collision_width / 2 &&
        y + collision_height / 2 > char.y - char.collision_height / 2 &&
        y - collision_height / 2 < char.y + char.collision_height / 2

      collides_y = y + dy - collision_height / 2 < char.y + char.collision_height / 2 &&
        y + dy + collision_height / 2 > char.y - char.collision_height / 2 &&
        x + collision_width / 2 > char.x - char.collision_width / 2 &&
        x - collision_width / 2 < char.x + char.collision_width / 2

      {collides_x, collides_y}
    end
  end
end
