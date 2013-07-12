require 'hashie'

dir_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob(dir_root + '/enginedata/**/*') { |file| require file if File.file?(file) }

class PSD
  class EngineData
    include Parser

    attr_reader :text, :node
    alias :result :node

    def self.load(file)
      self.new File.read(file)
    end

    def initialize(text)
      @text = Text.new(text)
    end

    def parsed?
      !@node.nil?
    end
  end
end
