class PSD
  class EngineData
    class Instruction
      class HashStart < Instruction
        def self.token; /^<<$/; end

        def execute!
          stack_push
          reset_node
          set_property
        end
      end
    end
  end
end