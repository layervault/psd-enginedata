require 'spec_helper'

describe 'Exporting' do
  before(:each) do
    @parser = PSD::EngineData.load('spec/files/enginedata')
    @parser.parse!
  end

  describe 'to css' do
    it "is possible" do
      @parser.respond_to?(:to_css)
      @parser.to_css
    end

    it "includes all customization values" do
      css = @parser.to_css

      css.should include "font-family"
      css.should include "font-size"
      css.should include "color"
    end

    it "produces valid code" do
      css = @parser.to_css

      # All lines end with semicolons
      css.split("\n").each { |l| l[-1].should == ";" }

      # Produces the correct and valid RGBA value
      match = /rgba\((\d+), (\d+), (\d+), (\d+)\)/i.match(css)
      match[1..-1].should == ['19', '120', '98', '255']
    end
  end
end