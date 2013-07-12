require 'hashie'

dir_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob(dir_root + '/enginedata/**/*') { |file| require file if File.file?(file) }

class PSD
  class EngineData
    include Parser

    attr_reader :document

    def self.load(file)
      self.new File.read(file)
    end

    def initialize(text)
      @document = Document.new(text)
    end

    [:parse!, :parsed?, :result].each do |m|
      define_method m do
        @document.send(m)
      end
    end
  end
end
