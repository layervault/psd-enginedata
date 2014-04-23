# -*- encoding : utf-8 -*-
require 'hashie'

dir_root = File.dirname(File.absolute_path(__FILE__)) + '/enginedata'
[
  '/instructions/*',
  '/exporters/*',
  '/**/*'
].each do |path|
  Dir.glob(dir_root + path) { |file| require file if File.file?(file) }
end

class PSD
  # General purpose parser for the text data markup present within PSD documents.
  class EngineData
    attr_reader   :text
    attr_accessor :property_stack, :node_stack, :property, :node
    alias :result :node

    include DocumentHelpers

    # All of the instructions as defined by the EngineData spec.
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

    # Read a file containing EngineData markup and initialize a new instance.
    def self.load(file)
      self.new File.new(file, 'rb').read
    end

    # Create a new Text instance and initialize our parsing stacks.
    def initialize(text)
      @text = Text.new(text)

      @property_stack = []
      @node_stack = []

      @property = :root
      @node = nil

      @parsed = false
    end

    # Parses the full document.
    def parse!
      return if parsed?

      while true
        line = @text.current
        @parsed = true and return if line.nil?

        parse_tokens(line)
        @text.next!
      end
    end

    # Has the document been parsed yet?
    def parsed?
      @parsed
    end

    # Go through each instruction until a token match is found, then parse the
    # matches.
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
