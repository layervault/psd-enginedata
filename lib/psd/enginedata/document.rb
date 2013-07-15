class PSD
  class EngineData
    class Document
      attr_reader   :text
      attr_accessor :property_stack, :node_stack, :property, :node
      alias :result :node

      include DocumentHelpers
      include Export

      INSTRUCTIONS = [
        Instruction::HashStart,
        Instruction::HashEnd,
        Instruction::SingleLineArray,
        Instruction::MultiLineArrayStart,
        Instruction::MultiLineArrayEnd,
        Instruction::Property,
        Instruction::PropertyWithData,
        Instruction::String,
        Instruction::NumberWithDecimal,
        Instruction::Number,
        Instruction::Boolean,
        Instruction::Noop
      ]

      def initialize(text)
        @text = Text.new(text)

        @property_stack = []
        @node_stack = []

        @property = :root
        @node = nil
      end

      def parse!
        while true
          line = @text.current
          return if line.nil?

          parse_tokens(line)
          @text.next!
        end
      end

      def parsed?
        !@node.nil?
      end

      def parse_tokens(text)
        INSTRUCTIONS.each do |inst|
          match = inst.match(text)
          return inst.new(self, text).execute! if match
        end

        # This is a hack for the Japanese character rules that the format embeds
        match = Instruction::String.match(text + @text.next)
        if match
          text += @text.next!
          return Instruction::String.new(self, text).execute!
        end

        raise TokenNotFound.new("Text = #{text.dump}, Line = #{@text.line + 1}")
      end
    end
  end
end