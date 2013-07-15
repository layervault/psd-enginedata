require 'hashie'

dir_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob(dir_root + '/enginedata/instructions/*') { |file| require file if File.file?(file) }
Dir.glob(dir_root + '/enginedata/exporters/*') { |file| require file if File.file?(file) }

require dir_root + '/enginedata/document_helpers'
require dir_root + '/enginedata/export'
Dir.glob(dir_root + '/enginedata/**/*') { |file| require file if File.file?(file) }

class PSD
  class EngineData
    attr_reader :document

    DELEGATE = PSD::EngineData::Export.instance_methods + [
      :parse!,
      :parsed?,
      :result
    ]

    def self.load(file)
      self.new File.read(file)
    end

    def initialize(text)
      @document = Document.new(text)
    end

    DELEGATE.each do |m|
      define_method m do
        @document.send(m)
      end
    end
  end
end
