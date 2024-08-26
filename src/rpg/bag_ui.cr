require "./bag"

module RPG
  class BagUI
    BackgroundColor = SF::Color.new(17, 17, 17, 170)
    OutlineColor = SF::Color.new(102, 102, 102)
    OutlineThickness = 4

    TitleFontSize = 16
    TitleTextColor = SF::Color::White

    Padding = 16
    CellCols = 8

    OpenBagKeys = [Keys::B, Keys::Tab]
    OpenBagJoystickButtons = [Joysticks::Back]

    @@show = false
    @@width : Float32?
    @@height : Float32?
    @@x : Float32?
    @@y : Float32?
    @@background_rect : SF::RectangleShape?
    @@title_text : SF::Text?
    @@grid_cell_size : Float32?

    def self.update(keys, joysticks)
      return unless keys.just_pressed?(OpenBagKeys) || joysticks.just_pressed?(OpenBagJoystickButtons)

      show? ? hide : show
    end

    def self.show?
      @@show
    end

    def self.show
      @@show = true
    end

    def self.hide
      @@show = false
    end

    def self.width
      @@width ||= Screen.width * 0.75
    end

    def self.height
      @@height ||= Screen.height * 0.75
    end

    def self.x
      @@x ||= Screen.width / 2 - width / 2
    end

    def self.y
      @@y ||= Screen.height / 2 - height / 2
    end

    def self.background_rect : SF::RectangleShape
      if rect = @@background_rect
        return rect
      end

      rect = SF::RectangleShape.new({width, height})
      rect.fill_color = BackgroundColor
      rect.outline_color = OutlineColor
      rect.outline_thickness = OutlineThickness
      rect.position = {x, y}

      @@background_rect = rect

      rect
    end

    def self.grid_cell_size
      @@grid_cell_size ||= (width - Padding * 2) / CellCols
    end

    def self.title_text : SF::Text
      if text = @@title_text
        return text
      end

      text = SF::Text.new("Bag", Font.default, TitleFontSize)
      text.fill_color = TitleTextColor
      text.position = {x + Padding, y + Padding}

      @@title_text = text

      text
    end

    def self.draw(window : SF::RenderWindow, bag : Bag)
      return unless show?

      window.draw(background_rect)
      window.draw(title_text)
      draw_items(window, bag)
    end

    def self.draw_items(window, bag)
      dy = Padding + title_text.global_bounds.height + Padding
      dx = Padding

      bag.items.values.in_slices_of(CellCols).each_with_index do |items, row|
        items.each_with_index do |item, col|
          item.draw_ui(window, grid_cell_size, x + dx, y + dy, row, col)
        end
      end
    end
  end
end
