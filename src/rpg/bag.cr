require "./bag_item"

module RPG
  class Bag
    alias Items = Hash(String, BagItem)
    getter items : Hash(String, BagItem)

    def initialize
      @items = Items.new
    end

    def add(name : String)
      key = BagItem.key(name)

      if items.has_key?(key)
        items[key].add
      else
        items[key] = BagItem.new(name)
      end
    end

    def remove(name : String)
      key = BagItem.key(name)

      if items.has_key?(key)
        items[key].remove

        items.delete(key) if items[key].empty?
      end
    end
  end
end
