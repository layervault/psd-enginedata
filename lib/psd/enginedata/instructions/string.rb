# -*- encoding : utf-8 -*-
class PSD
  class EngineData
    class Instruction
      class String < Instruction
        def self.token; /^\(\u{2db}\u{2c7}(.*)\)$/; end

        def execute!
          match[1].gsub(/\r/, "\n").strip
        end
      end
    end
  end
end
