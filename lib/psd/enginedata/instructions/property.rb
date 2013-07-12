class PSD
  class EngineData
    class Instruction
      class Property < Instruction
        def self.token; /^\/(\w+)$/; end

        def execute!
          set_property match[1]
        end
      end
    end
  end
end