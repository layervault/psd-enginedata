class PSD
  class EngineData
    class Instruction
      class HashStart < Instruction
        TOKEN = /^<<$/

        def execute!
          push
          reset_node
          reset_property
        end
      end
    end
  end
end