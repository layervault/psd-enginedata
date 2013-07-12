class PSD
  class EngineData
    module Parser
      TOKENS = {
        hash_start: /^<<$/,
        hash_end: /^>>$/,
        single_line_array: /^\[(.*)\]$/,
        multi_line_array_start: /^\/(\w+) \[$/,
        multi_line_array_end: /^\]$/,
        property: /^\/(\w+)$/,
        property_with_data: /^\/(\w+) (.*)$/,
        string:   /^\(\u{2db}\u{2c7}(.*)\)$/,
        number_with_decimal: /^(\d*)\.(\d+)$/,
        number: /^(\d+)$/,
        boolean: /^(true|false)$/,
        noop: /^$/
      }

      def parse!
        return self if parsed?

        @property_stack = []
        @node_stack = []

        @property = :root
        @node = nil

        parse_document
      end

      private

      def parse_document
        while true
          line = @text.current
          return if line.nil?

          parse_tokens(line)
          @text.next!
        end
      end

      def parse_tokens(text)
        TOKENS.each do |type, r|
          match = r.match(text)
          if match
            return self.send(type, match)
          end
        end

        # This is a hack for the Japanese character rules that the format embeds
        match = TOKENS[:string].match(text + @text.next)
        if match
          @text.next!
          return string(match)
        end

        raise TokenNotFound.new("Text = #{text.dump}, Line = #{@text.line + 1}")
      end

      def noop(match)
      end

      def hash_start(match)
        @node_stack.push @node
        @property_stack.push @property
        @node = Node.new
        @property = nil
      end

      def hash_end(match)
        node = @node_stack.pop
        property = @property_stack.pop
        return if node.nil?

        if node.is_a?(PSD::EngineData::Node)
          node[property] = @node
        elsif node.is_a?(Array)
          node.push @node
        end

        @node = node
      end

      def single_line_array(match)
        items = match[1].strip.split(" ")
        data = []
        items.each do |item|
          data.push parse_tokens(item)
        end

        return data
      end

      def multi_line_array_start(match)

        @node_stack.push @node
        @property_stack.push match[1]

        @node = []
        @property = nil
      end

      def multi_line_array_end(match)
        node = @node_stack.pop
        property = @property_stack.pop

        if node.is_a?(PSD::EngineData::Node)
          node[property] = @node
        elsif node.is_a?(Array)
          node.push @node
        end

        @node = node
      end

      def property(match)
        @property = match[1]
      end

      def property_with_data(match)
        @property = match[1]
        data = parse_tokens(match[2])


        if @node.is_a?(PSD::EngineData::Node)
          @node[@property] = data
        elsif @node.is_a?(Array)
          @node.push data
        end
      end

      def string(match)
        match[1].gsub(/\r/, "\n").strip
      end

      def number(match)
        match[1].to_i
      end

      def number_with_decimal(match)
        "#{match[1]}.#{match[2]}".to_f
      end

      def boolean(match)
        match[1] == 'true' ? true : false
      end
    end
  end
end