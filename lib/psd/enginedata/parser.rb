class PSD
  class EngineData
    module Parser
      TOKENS = {
        hash_start: /^<<$/,
        hash_end: /^>>$/,
        property: /^\/(\w+)$/,
        property_with_data: /^\/(\w+) (.*)$/,
        string:   /\(\u{2db}\u{2c7}(.*)\)$/,
        number: /(\d+)$/,
        number_with_decimal: /(\d+)\.(\d+)$/,
        boolean: /(true|false)$/
      }

      def parse!
        return self if parsed?

        @stack = []
        @property = :root
        @node = Node.new
        @result = Result.new

        parse_document
        build_result
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

      def build_result
        @node.build
      end

      def parse_tokens(text)
        puts "PARSING: #{text}"
        TOKENS.each do |type, r|
          match = r.match(text)
          if match
            return self.send(type, match)
          end
        end

        raise TokenNotFound.new("Text = #{text}")
      end

      def hash_start(match)
        puts 'hash_start'
        @node.data = {}

        @node = Node.new
        puts "Stack = #{@stack.inspect}"
      end

      def hash_end(match)
        puts 'hash_end'
        parent = @stack.pop
        puts "Stack = #{@stack.inspect}"
        parent.data[@node.property] = @node
        @node = parent
      end

      def property(match)
        @node.property = match[1]
        puts "property = #{@property}"
      end

      def property_with_data(match)
        property = match[1]
        data = parse_tokens(match[2])

        puts "property: #{match[1]}, data: #{data}"

        @node.data[property] = data
      end

      def string(match)
        puts "string = #{match[1]}"
        match[1]
      end

      def number(match)
        puts "number = #{match[1]}"
        match[1].to_i
      end

      def number_with_decimal(match)
        puts "number = #{match[1]}.#{match[2]}"
        "#{match[1]}.#{match[2]}".to_f
      end

      def boolean(match)
        puts "boolean = #{match[1]}"
        match[1] == 'true' ? true : false
      end
    end
  end
end