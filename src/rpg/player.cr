module RPG
  class Player
    getter x : Int32 | Float32
    getter y : Int32 | Float32
    getter animations
    getter shadow_sprite : SF::Sprite

    Size = 64
    SpriteWidth = 64
    SpriteHeight = 96
    Speed = 320
    Sheet = "./assets/player.png"
    ShadowSprite = "./assets/shadow.png"

    BodyColor = SF::Color.new(217, 160, 102)
    ShadowColor = SF::Color.new(0, 0, 0, 63)
    ShadowDropColor = SF::Color.new(0, 0, 0, 127)

    def initialize(x = 0, y = 0)
      # sprite size
      @x = x
      @y = y

      # animations
      idle = GSF::Animation.new(2, loops: false)
      idle.add(Sheet, 0, 0, SpriteWidth, SpriteHeight)

      @animations = GSF::Animations.new(:idle, idle)

      init_animations

      # shadow sprite
      texture = SF::Texture.from_file(ShadowSprite)
      texture.smooth = false

      @shadow_sprite = SF::Sprite.new(texture)
      @shadow_sprite.origin = texture.size / 2.0
    end

    def init_animations
      frames = 2
      fps_factor = 30
      loops = true

      [:walk_down, :walk_up, :walk_left].each_with_index do |name, row|
        add_animation(name, row, frames, fps_factor, loops)
      end

      add_animation(:walk_right, 2, frames, fps_factor, loops, flip_horizontal: true)

      animations.play(:walk_down)
    end

    def add_animation(name, row, frames, fps_factor, loops, flip_horizontal = false)
      animation = GSF::Animation.new(fps_factor, loops: loops)

      frames.times do |i|
        animation.add(
          filename: Sheet,
          x: i * SpriteWidth,
          y: row * SpriteHeight,
          width: SpriteWidth,
          height: SpriteHeight
        )
      end

      animations.add(name, animation, flip_horizontal: flip_horizontal)
    end

    def size
      Size
    end

    def update(frame_time, keys : Keys)
      update_movement(frame_time, keys)
      animations.update(frame_time)
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

    def move_with_speed(frame_time, dx, dy)
      speed = Speed
      directional_speed = dx != 0 && dy != 0 ? speed / 1.4142 : speed
      dx *= (directional_speed * frame_time).to_f32
      dy *= (directional_speed * frame_time).to_f32

      {dx, dy}
    end

    def move_with_level(dx, dy)
      # screen collisions
      dx = 0 if x + dx < 0 || x + dx + size > Screen.width
      dy = 0 if y + dy < 0 || y + dy + size > Screen.height

      {dx, dy}
    end

    def animate_move(dx, dy)
      if dy > 0
        animations.play(:walk_down)
      elsif dy < 0
        animations.play(:walk_up)
      elsif dx > 0
        animations.play(:walk_right)
      elsif dx < 0
        animations.play(:walk_left)
      end
    end

    def move(dx, dy)
      @x += dx
      @y += dy
    end

    def jump(x, y)
      @x = x
      @y = y
    end

    def draw(window : SF::RenderWindow)
      draw_shadow(window)
      animations.draw(window, x, y - SpriteHeight / 2, color: BodyColor)
    end

    def draw_shadow(window)
      shadow_sprite.position = {x, y}

      window.draw(shadow_sprite)
    end
  end
end
