require 'hashie'

dir_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob(dir_root + '/enginedata/**/*') { |file| require file if File.file?(file) }

class PSD
  class EngineData
    include Parser

    attr_reader :text, :result, :node
    alias :data :result

    def self.load(file)
      self.new File.read(file)
    end

    def initialize(text)
      @text = Text.new(text)
      @result = nil
    end

    def parsed?
      !@result.nil?
    end
  end
end
