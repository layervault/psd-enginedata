# -*- encoding : utf-8 -*-
class PSD
  class EngineData
    # A single instruction as defined by the EngineData spec.
    class Instruction
      # The regex for the token, defaulted to nil. Override this.
      def self.token; end

      # Checks to see if the given text is a match for this token.
      def self.match(text)
        begin
          token.match(text)
        rescue Encoding::CompatibilityError
          nil
        end
      end

      # Stores a reference to the EngineData document and the current
      # String being parsed.
      def initialize(document, text)
        @document = document
        @text = text
      end

      # Returns the regex match to the current string.
      def match
        self.class.match @text
      end

      # Once matched, we execute the instruction and apply the changes
      # to the parsed data.
      def execute!; end

      def method_missing(method, *args, &block)
        if @document.respond_to?(method)
          return @document.send(method, *args)
        end

        super
      end
    end
  end
end
