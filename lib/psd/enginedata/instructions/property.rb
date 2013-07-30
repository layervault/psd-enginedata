# -*- encoding : utf-8 -*-
class PSD
  class EngineData
    class Instruction
      class Property < Instruction
        def self.token; /^\/([A-Z0-9]+)$/i; end

        def execute!
          set_property match[1]
        end
      end
    end
  end
end
