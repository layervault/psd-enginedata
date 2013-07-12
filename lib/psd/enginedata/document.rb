class PSD
  class EngineData
    class Document
      attr_reader   :text
      attr_accessor :property_stack, :node_stack, :property, :node

      INSTRUCTIONS = [
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

      def result
        @node
      end

      def push
        @node_stack.push @node
        @property_stack.push @property
      end

      def pop
        @node_stack.pop, @property_stack.pop
      end

      def reset_node
        @node = Node.new
      end

      def reset_property
        @property = nil
      end

      private

      def parse_tokens(text)
        INSTRUCTIONS.each do |inst|
          match = inst.match(text)
          return inst.new(self, text).execute! if match
        end

        # This is a hack for the Japanese character rules that the format embeds
        match = Instruction::String.match(text + @text.next)
        if match
          @text.next!
          return Instruction::String.new(self, text + @text.next).execute!
        end

        raise TokenNotFound.new("Text = #{text.dump}, Line = #{@text.line + 1}")
      end
    end
  end
end