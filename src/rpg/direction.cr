module RPG
  enum Direction
    Up
    UpRight
    Right
    DownRight
    Down
    DownLeft
    Left
    UpLeft

    def left_or_up?
      left? || up_left? || up?
    end

    def left_or_down?
      left? || down_left? || down?
    end

    def left_any?
      left? || up_left? || up? || down_left? || down?
    end

    def right_or_up?
      right? || up_right? || up?
    end

    def right_or_down?
      right? || down_right? || down?
    end

    def right_any?
      right? || up_right? || up? || down_right? || down?
    end

    def up_any?
      up? || up_right? || up_left?
    end

    def down_any?
      down? || down_right? || down_left?
    end
  end
end
