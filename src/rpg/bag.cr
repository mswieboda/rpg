require "./item"

module RPG
  class Bag
    alias Items = Hash(String, Item)
    getter items : Hash(String, Item)

    def initialize
      @items = Items.new
    end

    def add(key : String)
      if items.has_key?(key)
        items[key].add
      else
        items[key] = Item.get(key)
      end
    end

    def remove(name : String)
      key = Item.key(name)

      if items.has_key?(key)
        items[key].remove

        items.delete(key) if items[key].empty?
      end
    end
  end
end
