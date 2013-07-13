class PSD
  class EngineData
    class Instruction
      class PropertyWithData < Instruction
        def self.token; /^\/([A-Z0-9]+) (.*)$/i; end

        def execute!
          set_property match[1]
          data = parse_tokens match[2]

          if node.is_a?(PSD::EngineData::Node)
            node[property] = data
          elsif node.is_a?(Array)
            node.push data
          end
        end
      end
    end
  end
end