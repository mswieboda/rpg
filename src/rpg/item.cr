module RPG
  class Item
    LabelFontSize = 12
    LabelTextColor = SF::Color::White
    LabelBottomPadding = 8
    AmountFontSize = 10
    AmountTextColor = SF::Color::White

    getter name : String
    getter key : String
    getter amount : Int32
    getter fill_color : SF::Color

    @@label_text : SF::Text?
    @@amount_text : SF::Text?

    def initialize(@key : String, @name : String, @fill_color = SF::Color.new)
      @amount = 1
    end

    def self.init_data
      @@item_data = YAML.parse(File.read("./assets/data/items.yml"))
    end

    def self.get(key : String)
      name = key.gsub('_', ' ').titleize

      if item_data = @@item_data
        unless item_data.as_h.has_key?(key)
          return new(key, name)
        end
      else
        return new(key, name)
      end

      data = item_data[key]

      name = ""

      if data.as_h.has_key?("name")
        name = data["name"].as_s
      end

      fill_color = SF::Color.new

      if data.as_h.has_key?("fill_color")
        red = 0
        green = 0
        blue = 0

        if data["fill_color"].as_h.has_key?("red")
          red = data["fill_color"]["red"].as_i
        end

        if data["fill_color"].as_h.has_key?("green")
          green = data["fill_color"]["green"].as_i
        end

        if data["fill_color"].as_h.has_key?("blue")
          blue = data["fill_color"]["blue"].as_i
        end

        fill_color = SF::Color.new(red, green, blue)
      end

      new(
        key: key,
        name: name,
        fill_color: fill_color
      )
    end

    def self.label_text : SF::Text
      if text = @@label_text
        return text
      end

      text = SF::Text.new("", Font.default, LabelFontSize)
      text.fill_color = LabelTextColor

      @@label_text = text

      text
    end

    def self.amount_text : SF::Text
      if text = @@amount_text
        return text
      end

      text = SF::Text.new("2", Font.default, AmountFontSize)
      text.fill_color = AmountTextColor

      @@amount_text = text

      text
    end

    def add
      @amount += 1
    end

    def remove
      @amount -= 1
    end

    def empty?
      amount <= 0
    end

    def self.word_wrap_lines(text, width)
      label_text.string = text
      label_width = label_text.global_bounds.width

      return [text] if label_width < width

      lines = [""]
      line_index = 0
      words = text.split
      label_text.string = ""

      words.each_with_index do |word, index|
        label_text.string += word
        label_text.string += " " unless index >= words.size - 1
        line_width = label_text.global_bounds.width

        if line_width >= width
          line_index += 1
          lines << ""
          label_text.string = word
          label_text.string += " " unless index >= words.size - 1
        end

        lines[line_index] += word
        lines[line_index] += " " unless index >= words.size - 1
      end

      lines
    end

    def draw_ui_icon(window, radius, x, y)
      circle = SF::CircleShape.new(radius)
      circle.fill_color = fill_color
      circle.position = {x + radius, y + radius}

      window.draw(circle)
    end

    def draw_ui_label(window, grid_cell_size, radius, x, y)
      lines = self.class.word_wrap_lines(name, grid_cell_size)
      label_text = self.class.label_text
      amount_text = self.class.amount_text

      lines.each_with_index do |line, line_index|
        label_text.string = line
        line_width = label_text.global_bounds.width

        label_text.position = {
          x + grid_cell_size / 2 - line_width / 2,
          y + grid_cell_size + LabelFontSize * line_index - LabelFontSize - LabelFontSize / 2 * lines.size - LabelBottomPadding
        }

        window.draw(label_text)
      end

      if amount > 1
        amount_text.string = amount.to_s
        amount_text.position = {x + radius * 2.5, y + radius * 2.5}

        window.draw(amount_text)
      end
    end

    def draw_ui(window, grid_cell_size, dx, dy, row, col)
      x = dx + col * grid_cell_size
      y = dy + row * grid_cell_size
      radius = grid_cell_size / 4

      draw_ui_icon(window, radius, x, y)
      draw_ui_label(window, grid_cell_size, radius, x, y)
    end
  end
end
