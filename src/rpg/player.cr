require "./character"

module RPG
  class Player < Character
    def update(frame_time, keys : Keys)
      update_movement(frame_time, keys)

      super(frame_time)
    end

    def update_movement(frame_time, keys : Keys)
      dx = 0
      dy = 0

      dy -= 1 if keys.pressed?([Keys::W])
      dx -= 1 if keys.pressed?([Keys::A])
      dy += 1 if keys.pressed?([Keys::S])
      dx += 1 if keys.pressed?([Keys::D])

      return if dx == 0 && dy == 0

      dx, dy = move_with_speed(frame_time, dx, dy)
      dx, dy = move_with_level(dx, dy)

      return if dx == 0 && dy == 0

      animate_move(dx, dy)
      move(dx, dy)
    end

    def move_with_level(dx, dy)
      # screen collisions
      dx = 0 if x + dx < 0 || x + dx + size > Screen.width
      dy = 0 if y + dy < 0 || y + dy + size > Screen.height

      {dx, dy}
    end
  end
end
