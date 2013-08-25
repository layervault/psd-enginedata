# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'Parser' do
  before(:each) do
    @parser = PSD::EngineData.load('spec/files/enginedata')
  end

  it "is ready to parse" do
    expect(@parser.text).to_not be_nil
    expect(@parser).to_not be_parsed
  end

  it "does not error when parsing" do
    @parser.parse!
    expect(@parser).to be_parsed
  end

  it "contains the proper data" do
    @parser.parse!

    expect(@parser.result.EngineDict.Editor.Text).to eq("Make a change and save.")
    expect(@parser.result.ResourceDict.FontSet.first.Name).to eq("HelveticaNeue-Light")
  end
end
