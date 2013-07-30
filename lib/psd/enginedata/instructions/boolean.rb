# -*- encoding : utf-8 -*-
class PSD
  class EngineData
    class Instruction
      class Boolean < Instruction
        def self.token; /^(true|false)$/; end

        def execute!
          match[1] == 'true' ? true : false
        end
      end
    end
  end
end
