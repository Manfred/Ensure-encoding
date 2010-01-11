# encoding: utf-8

require File.expand_path('../../start', __FILE__)

describe "Ensure::Encoding, concerning sniff_encoding" do
  it "should try to sniff encodings in a sensible way" do
    [
      ['UTF-8', Encoding::UTF_8],
      ['UTF-16LE', Encoding::UTF_16LE],
      ['UTF-16BE', Encoding::UTF_16BE]
    ].each do |source, expected|
      e, _ = example(source)
      Ensure::Encoding.sniff_encoding(e).should == expected
    end
  end
end