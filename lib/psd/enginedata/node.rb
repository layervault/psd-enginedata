class PSD
  class EngineData
    class Node
      attr_accessor :property, :data

      def initialize(data={})
        @property = nil
        @data = nil

        data.each { |k, v| self.send("#{k}=", v) }
      end

      def has_data?
        @data.nil?
      end

      def set_data(node)
        @data[@property] = node
      end

      def build
        
      end
    end
  end
end