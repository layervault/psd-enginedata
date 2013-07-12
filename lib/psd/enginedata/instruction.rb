class PSD
  class EngineData
    class Instruction
      def self.token; end

      def self.match(text)
        token.match(text)
      end

      def initialize(document, text)
        @document = document
        @text = text
      end

      def match
        self.class.match @text
      end

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