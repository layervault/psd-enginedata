# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'Parser' do
  let(:parser) { PSD::EngineData.load('spec/files/enginedata') }

  it "is ready to parse" do
    expect(parser.text).to_not be_nil
    expect(parser).to_not be_parsed
  end

  it "does not error when parsing" do
    parser.parse!
    expect(parser).to be_parsed
  end

  describe "result data" do
    before(:each) do
      parser.parse!
    end

    it "contains the proper data" do
      expect(parser.result.EngineDict.Editor.Text).to eq("PSD · Enginedata")
    end

    it "parses font data" do
      names = parser.result.ResourceDict.FontSet.map(&:Name)
      expect(names).to include 'MyriadPro-Regular'
    end
  end
end
