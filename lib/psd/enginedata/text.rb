class PSD
  class EngineData
    # Sanitizes and helps with access to the document text.
    class Text
      # The current document split by newlines into an array.
      attr_reader   :text

      # The current line number in the document.
      attr_accessor :line

      # Stores the document as a newline-split array and initializes
      # the current line to 0.
      def initialize(text)
        @text = text.split("\n")
        @line = 0
      end

      # Returns the current line stripped of any tabs and padding.
      def current
        return nil if at_end?
        @text[@line].gsub(/\t/, "").strip
      end

      # Are we at the end of the document?
      def at_end?
        @text[@line].nil?
      end

      # Moves the line pointer to the next line and returns it.
      def next!
        @line += 1
        current
      end

      # Peeks at the next line in the document without moving the
      # line pointer.
      def next
        @text[@line + 1]
      end

      # Returns the number of lines in the document.
      def length
        @text.length
      end
      alias :size :length
    end
  end
end