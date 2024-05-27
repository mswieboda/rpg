require "./bag"

module RPG
  class BagUI
    BackgroundColor = SF::Color.new(17, 17, 17, 170)
    OutlineColor = SF::Color.new(102, 102, 102)
    OutlineThickness = 4

    TitleFontSize = 24
    TitleTextColor = SF::Color::White

    Padding = 32

    CellCols = 6
    CellBackgroundColor = SF::Color.new(17, 17, 17, 102)
    CellOutlineColor = SF::Color.new(102, 102, 102, 102)
    CellOutlineThickness = 2

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
    @@grid_cell_rect : SF::RectangleShape?

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
      @@width ||= Screen.width / 2
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
      rect.outline_thickness = -OutlineThickness
      rect.position = {x, y}

      @@background_rect = rect

      rect
    end

    def self.grid_cell_size
      @@grid_cell_size ||= (width - Padding * 2) / CellCols
    end

    def self.grid_cell_rect : SF::RectangleShape
      if rect = @@grid_cell_rect
        return rect
      end

      rect = SF::RectangleShape.new({grid_cell_size, grid_cell_size})
      rect.fill_color = CellBackgroundColor
      rect.outline_color = CellOutlineColor
      rect.outline_thickness = -CellOutlineThickness

      @@grid_cell_rect = rect

      rect
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
      draw_bag_items_grid(window, bag)
    end

    def self.draw_bag_items_grid(window, bag)
      # TODO: maybe memoize these calc'd vars via a Tuple
      dy = Padding + title_text.global_bounds.height + Padding
      grid_height = height - dy
      rows = (grid_height / grid_cell_size).to_i
      remainder_y = grid_height % grid_cell_size
      dx = Padding
      dy += remainder_y - dx

      CellCols.times do |col|
        rows.times do |row|
          draw_bag_item_cell(window, "thing", dx, dy, row, col)
        end
      end
    end

    def self.draw_bag_item_cell(window, item, dx, dy, row, col)
      rect = grid_cell_rect
      rect.position = {x + dx + col * grid_cell_size, y + dy + row * grid_cell_size}

      window.draw(rect)
    end
  end
end
