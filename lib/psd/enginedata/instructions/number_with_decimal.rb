class PSD
  class EngineData
    class Instruction
      class NumberWithDecimal < Instruction
        def self.token; /^(\d*)\.(\d+)$/; end

        def execute!
          "#{match[1]}.#{match[2]}".to_f
        end
      end
    end
  end
end