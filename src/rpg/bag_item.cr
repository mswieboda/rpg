module RPG
  class BagItem
    getter name : String
    getter key : String
    getter count : Int32

    def initialize(@name : String, @key : String = "")
      if @key.empty?
        @key = self.class.key(@name)
      end

      @count = 1
    end

    def self.key(name : String)
      name.underscore
    end

    def add
      @count += 1
    end

    def remove
      @count -= 1
    end

    def empty?
      count <= 0
    end
  end
end
