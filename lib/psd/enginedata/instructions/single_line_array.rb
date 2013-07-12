class PSD
  class EngineData
    class Instruction
      class SingleLineArray < Instruction
        def self.token; /^\[(.*)\]$/; end

        def execute!
          items = match[1].strip.split(" ")
          data = []

          items.each do |item|
            data << parse_tokens(item)
          end

          return data
        end
      end
    end
  end
end