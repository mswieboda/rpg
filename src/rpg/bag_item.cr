module RPG
  class BagItem
    getter name : String
    getter key : String
    getter amount : Int32
    getter fill_color : SF::Color

    def initialize(@key : String, @name : String, @fill_color = SF::Color.new)
      @amount = 1
    end

    def self.init_data
      @@item_data = YAML.parse(File.read("./assets/data/items/bag_items.yml"))
    end

    def self.get(key : String)
      if item_data = @@item_data
        unless item_data.as_h.has_key?(key)
          return BagItem.new(key, key)
        end
      else
        return BagItem.new(key, key)
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

    def add
      @amount += 1
    end

    def remove
      @amount -= 1
    end

    def empty?
      amount <= 0
    end
  end
end
