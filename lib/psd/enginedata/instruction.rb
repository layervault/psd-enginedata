class PSD
  class EngineData
    class Instruction
      def self.match(text)
        TOKEN.match(text)
      end

      def initialize(document)
        @document = document
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