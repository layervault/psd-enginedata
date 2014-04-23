# -*- encoding : utf-8 -*-
class PSD
  class EngineData
    class Instruction
      class String < Instruction
        def self.token; Regexp.new('^\(\xFE\xFF(.*)\)$'.force_encoding('binary')); end

        def execute!
          data = self.class.token.match(
            @text.force_encoding('binary')
          )[1]

          begin
            data
              .force_encoding('UTF-16BE')
              .encode('UTF-8', 'UTF-16BE')
              .strip
          rescue
            data
          end
        end
      end
    end
  end
end
