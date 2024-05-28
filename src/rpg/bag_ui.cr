require "./bag"

module RPG
  class BagUI
    BackgroundColor = SF::Color.new(17, 17, 17, 170)
    OutlineColor = SF::Color.new(102, 102, 102)
    OutlineThickness = 4

    TitleFontSize = 16
    TitleTextColor = SF::Color::White

    ItemLabelFontSize = 12
    ItemLabelTextColor = SF::Color::White
    ItemLabelBottomPadding = 8
    ItemAmountFontSize = 10
    ItemAmountTextColor = SF::Color::White

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
    @@item_label_text : SF::Text?
    @@item_amount_text : SF::Text?
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

    def self.item_label_text : SF::Text
      if text = @@item_label_text
        return text
      end

      text = SF::Text.new("", Font.default, ItemLabelFontSize)
      text.fill_color = ItemLabelTextColor

      @@item_label_text = text

      text
    end

    def self.item_amount_text : SF::Text
      if text = @@item_amount_text
        return text
      end

      text = SF::Text.new("2", Font.default, ItemAmountFontSize)
      text.fill_color = ItemAmountTextColor

      @@item_amount_text = text

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
          draw_item(window, item, dx, dy, row, col)
        end
      end
    end

    def self.draw_item(window, item, dx, dy, row, col)
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
      lines = word_wrap_lines(item.name, grid_cell_size)

      lines.each_with_index do |line, line_index|
        item_label_text.string = line
        line_width = item_label_text.global_bounds.width

        item_label_text.position = {
          ix + grid_cell_size / 2 - line_width / 2,
          iy + grid_cell_size + ItemLabelFontSize * line_index - ItemLabelFontSize - ItemLabelFontSize / 2 * lines.size - ItemLabelBottomPadding
        }

        window.draw(item_label_text)
      end

      if item.amount > 1
        item_amount_text.string = item.amount.to_s
        item_amount_text.position = {ix + radius * 2.5, iy + radius * 2.5}

        window.draw(item_amount_text)
      end
    end

    def self.word_wrap_lines(text, width)
      item_label_text.string = text
      label_width = item_label_text.global_bounds.width

      return [text] if label_width < width

      lines = [""]
      line_index = 0
      words = text.split
      item_label_text.string = ""

      words.each_with_index do |word, index|
        item_label_text.string += word
        item_label_text.string += " " unless index >= words.size - 1
        line_width = item_label_text.global_bounds.width

        if line_width >= width
          line_index += 1
          lines << ""
          item_label_text.string = word
          item_label_text.string += " " unless index >= words.size - 1
        end

        lines[line_index] += word
        lines[line_index] += " " unless index >= words.size - 1
      end

      lines
    end
  end
end
