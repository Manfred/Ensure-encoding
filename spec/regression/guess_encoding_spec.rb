# encoding: utf-8

require File.expand_path('../../start', __FILE__)

describe "Ensure::Encoding, concerning guess_encoding" do
  it "should guess the first encoding from the list in which the data is valid" do
    [
      ['UTF-8',     ['ASCII-8BIT', 'UTF-8'],     Encoding::ASCII_8BIT],
      ['UTF-8',     ['US-ASCII', 'UTF-8'],       Encoding::UTF_8],
      ['UTF-8',     ['ISO-8859-1', 'UTF-8'],     Encoding::ISO_8859_1],
      ['UTF-8',     ['US-ASCII', 'US-ASCII'],    nil],
      ['Shift_JIS', ['ASCII-8BIT', 'Shift_JIS'], Encoding::ASCII_8BIT],
      ['Shift_JIS', ['US-ASCII', 'Shift_JIS'],   Encoding::Shift_JIS],
      ['UTF-16LE',  ['UTF-8', 'UTF-16LE'],       Encoding::UTF_16LE],
      ['UTF-16BE',  ['UTF-8', 'UTF-16BE'],       Encoding::UTF_16BE]
    ].each do |source, guesses, expected|
      e, _ = example(source)
      Ensure::Encoding.guess_encoding(e, guesses).should == expected
    end
  end
end