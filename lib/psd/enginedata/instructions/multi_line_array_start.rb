class PSD
  class EngineData
    class Instruction
      class MultiLineArrayStart < Instruction
        def self.token; /^\/(\w+) \[$/; end

        def execute!
          stack_push match[1]
          set_node []
          set_property
        end
      end
    end
  end
end