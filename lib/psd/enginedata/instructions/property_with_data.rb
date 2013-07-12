class PSD
  class EngineData
    class Instruction
      class PropertyWithData < Instruction
        def self.token; /^\/(\w+) (.*)$/; end

        def execute!
          set_property match[1]
          data = parse_tokens match[2]

          if @document.node.is_a?(PSD::EngineData::Node)
            @document.node[@document.property] = data
          elsif @document.node.is_a?(Array)
            @document.node.push data
          end
        end
      end
    end
  end
end