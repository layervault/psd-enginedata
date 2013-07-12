require 'spec_helper'

describe 'Parser' do
  before(:each) do
    @parser = PSD::EngineData.load('spec/files/enginedata')
  end

  it "is ready to parse" do
    @parser.text.length.should be > 0
    @parser.parsed?.should be_false
  end

  it "does not error when parsing" do
    @parser.parse!
    @parser.parsed?.should be_true
  end
end