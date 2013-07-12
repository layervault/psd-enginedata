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

      def at_root?
        @stack.size == 0
      end

      def parse_document
        while true
          line = @text.current
          return if line.nil?

          parse_tokens(line)
          @text.next!
        end
      end

      def parse_tokens(text)
        puts "PARSING: #{text.dump}"
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
        puts "NOOP"
      end

      def hash_start(match)
        puts 'hash_start'
        @node_stack.push @node
        @property_stack.push @property
        @node = Node.new
        @property = nil
      end

      def hash_end(match)
        puts 'hash_end'
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
        puts "Single line array: #{items.inspect}"
        data = []
        items.each do |item|
          data.push parse_tokens(item)
        end

        puts "Array result: #{data.inspect}"
        return data
      end

      def multi_line_array_start(match)
        puts "multi_line_array_start"

        @node_stack.push @node
        @property_stack.push match[1]

        @node = []
        @property = nil
      end

      def multi_line_array_end(match)
        puts "multi_line_array_end"
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
        puts "property = #{@property}"
      end

      def property_with_data(match)
        @property = match[1]
        data = parse_tokens(match[2])

        puts "property: #{match[1]}, data: #{data}"

        if @node.is_a?(PSD::EngineData::Node)
          @node[@property] = data
        elsif @node.is_a?(Array)
          @node.push data
        end
      end

      def string(match)
        puts "string = #{match[1]}"
        match[1].gsub(/\r/, "\n")
      end

      def number(match)
        puts "number = #{match[1]}"
        match[1].to_i
      end

      def number_with_decimal(match)
        puts "number w/ decimal = #{match[1]}.#{match[2]}"
        "#{match[1]}.#{match[2]}".to_f
      end

      def boolean(match)
        puts "boolean = #{match[1]}"
        match[1] == 'true' ? true : false
      end
    end
  end
end