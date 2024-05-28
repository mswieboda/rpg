require "./bag"

module RPG
  class BagUI
    BackgroundColor = SF::Color.new(17, 17, 17, 170)
    OutlineColor = SF::Color.new(102, 102, 102)
    OutlineThickness = 4

    TitleFontSize = 16
    TitleTextColor = SF::Color::White

    BagItemLabelFontSize = 12
    BagItemLabelTextColor = SF::Color::White
    BagItemLabelBottomPadding = 8
    BagItemAmountFontSize = 10
    BagItemAmountTextColor = SF::Color::White

    Padding = 16

    CellCols = 8
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
    @@bag_item_label_text : SF::Text?
    @@bag_item_amount_text : SF::Text?
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
      @@grid_cell_size ||= (width - Padding * 2 - OutlineThickness * 2) / CellCols
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

    def self.bag_item_label_text : SF::Text
      if text = @@bag_item_label_text
        return text
      end

      text = SF::Text.new("", Font.default, BagItemLabelFontSize)
      text.fill_color = BagItemLabelTextColor

      @@bag_item_label_text = text

      text
    end

    def self.bag_item_amount_text : SF::Text
      if text = @@bag_item_amount_text
        return text
      end

      text = SF::Text.new("1", Font.default, BagItemAmountFontSize)
      text.fill_color = BagItemAmountTextColor

      @@bag_item_amount_text = text

      text
    end

    def self.draw(window : SF::RenderWindow, bag : Bag)
      return unless show?

      window.draw(background_rect)
      window.draw(title_text)
      # draw_bag_items_grid(window)
      draw_bag_items(window, bag)
    end

    def self.draw_bag_items(window, bag)
      dy = Padding + title_text.global_bounds.height + Padding
      dx = Padding

      bag.items.values.in_slices_of(CellCols).each_with_index do |items, row|
        items.each_with_index do |item, col|
          draw_bag_item_cell(window, dx, dy, row, col)
          draw_bag_item(window, item, dx, dy, row, col)
        end
      end
    end

    def self.draw_bag_item_cell(window, dx, dy, row, col)
      rect = grid_cell_rect
      rect.position = {x + dx + col * grid_cell_size, y + dy + row * grid_cell_size}

      window.draw(rect)
    end

    def self.draw_bag_item(window, item, dx, dy, row, col)
      ix = x + dx + col * grid_cell_size
      iy = y + dy + row * grid_cell_size

      # icon
      radius = grid_cell_size / 4
      circle = SF::CircleShape.new(radius)
      circle.fill_color = item.fill_color
      circle.position = {
        ix + radius,
        iy + radius
      }

      window.draw(circle)

      # label
      bag_item_label_text.string = item.name
      label_width = bag_item_label_text.global_bounds.width
      bag_item_label_text.position = {
        ix + grid_cell_size / 2 - label_width / 2,
        iy + grid_cell_size - BagItemLabelFontSize - BagItemLabelBottomPadding
      }

      window.draw(bag_item_label_text)

      if item.amount > 1
        # amount
        bag_item_amount_text.string = item.amount.to_s
        bag_item_amount_text.position = {ix + radius * 2.5, iy + radius * 2.5}

        window.draw(bag_item_amount_text)
      end
    end
  end
end
