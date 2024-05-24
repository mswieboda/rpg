module RPG
  class Sign < Collidable
    getter shadow_sprite : SF::Sprite

    ShadowSprite = "./assets/sprites/shadow.png"

    def initialize(x = 0, y = 0, dialog_key = "")
      super

      @area_triggered = false

      # shadow sprite
      texture = SF::Texture.from_file(ShadowSprite)
      texture.smooth = false

      @shadow_sprite = SF::Sprite.new(texture)
      @shadow_sprite.origin = texture.size / 2.0
    end

    def action
      "read"
    end

    def draw(window : SF::RenderWindow)
      draw_shadow(window)
      draw_sign(window)
    end

    def draw_shadow(window)
      shadow_sprite.position = {x, y}

      window.draw(shadow_sprite)
    end

    def draw_sign(window)
      # shadow_sprite.position = {x, y}

      # window.draw(shadow_sprite)
    end
  end
end
