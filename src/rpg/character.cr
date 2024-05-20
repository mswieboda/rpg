module RPG
  class Character
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

      [:walk_down, :walk_up, :walk_left, :walk_left_up, :walk_left_down].each_with_index do |name, row|
        add_animation(name, row, frames, fps_factor, loops)
      end

      add_animation(:walk_right, 2, frames, fps_factor, loops, flip_horizontal: true)
      add_animation(:walk_right_up, 3, frames, fps_factor, loops, flip_horizontal: true)
      add_animation(:walk_right_down, 4, frames, fps_factor, loops, flip_horizontal: true)

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

    def update(frame_time)
      animations.update(frame_time)
    end

    def move_with_speed(frame_time, dx, dy)
      speed = Speed
      directional_speed = dx != 0 && dy != 0 ? speed / 1.4142 : speed
      dx *= (directional_speed * frame_time).to_f32
      dy *= (directional_speed * frame_time).to_f32

      {dx, dy}
    end

    def animate_move(dx, dy)
      if dx == 0
        if dy < 0
          animations.play(:walk_up)
        else
          animations.play(:walk_down)
        end
      elsif dx < 0
        if dy < 0
          animations.play(:walk_left_up)
        elsif dy > 0
          animations.play(:walk_left_down)
        else
          animations.play(:walk_left)
        end
      elsif dx > 0
        if dy < 0
          animations.play(:walk_right_up)
        elsif dy > 0
          animations.play(:walk_right_down)
        else
          animations.play(:walk_right)
        end
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

    def jump_to_tile(row, col, tile_size)
      jump(
        row * tile_size + (tile_size / 2).to_f32,
        col * tile_size + (tile_size / 2).to_f32
      )
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
