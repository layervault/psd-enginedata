class PSD
  class EngineData
    class Document
      attr_reader   :text
      attr_accessor :property_stack, :node_stack, :property, :node

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

      def result
        @node
      end

      def stack_push(property = nil, node = nil)
        node = @node if node.nil?
        property = @property if property.nil?

        @node_stack.push node
        @property_stack.push property
      end

      def stack_pop
        return @property_stack.pop, @node_stack.pop
      end

      def set_node(node)
        @node = node
      end

      def reset_node
        @node = Node.new
      end

      def set_property(property = nil)
        @property = property
      end

      def update_node(property, node)
        if node.is_a?(PSD::EngineData::Node)
          node[property] = @node
        elsif node.is_a?(Array)
          node.push @node
        end
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