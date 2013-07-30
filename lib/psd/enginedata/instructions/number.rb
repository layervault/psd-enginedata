# -*- encoding : utf-8 -*-
class PSD
  class EngineData
    class Instruction
      class Number < Instruction
        def self.token; /^(-?\d+)$/; end

        def execute!
          match[1].to_i
        end
      end
    end
  end
end
