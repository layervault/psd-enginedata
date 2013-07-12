class PSD
  class EngineData
    class Instruction
      class HashEnd < Instruction
        def self.token; /^>>$/; end

        def execute!
          property, node = stack_pop
          return if node.nil?

          update_node property, node
          set_node node
        end
      end
    end
  end
end