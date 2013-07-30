# -*- encoding : utf-8 -*-
class PSD
  class EngineData
    # A collection of helper methods that are used to manipulate the internal
    # data structure while parsing.
    module DocumentHelpers
      # Pushes a property and node onto the parsing stack.
      def stack_push(property = nil, node = nil)
        node = @node if node.nil?
        property = @property if property.nil?

        @node_stack.push node
        @property_stack.push property
      end

      # Pops a property and node from the parsing stack
      def stack_pop
        return @property_stack.pop, @node_stack.pop
      end

      # Sets the current active node
      def set_node(node)
        @node = node
      end

      # Creates a new node
      def reset_node
        @node = Node.new
      end

      # Sets the current active property
      def set_property(property = nil)
        @property = property
      end

      # Updates a node with a given property and child node.
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
