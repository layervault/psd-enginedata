class PSD
  class EngineData
    module DocumentHelpers
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
    end
  end
end