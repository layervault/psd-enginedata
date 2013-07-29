require 'spec_helper'

describe 'Parser' do
  before(:each) do
    @parser = PSD::EngineData.load('spec/files/enginedata')
  end

  it "is ready to parse" do
    @parser.text.should_not be_nil
    @parser.parsed?.should be_false
  end

  it "does not error when parsing" do
    @parser.parse!
    @parser.parsed?.should be_true
  end

  it "contains the proper data" do
    @parser.parse!
    @parser.result.EngineDict.Editor.Text.should == "Make a change and save."
    @parser.result.ResourceDict.FontSet.first.Name.should == "HelveticaNeue-Light"
  end
end