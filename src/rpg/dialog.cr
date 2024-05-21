require "./message"

module RPG
  class Dialog < GSF::Dialog
    def message_class
      Message
    end
  end
end
