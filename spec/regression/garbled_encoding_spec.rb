# encoding: utf-8

require File.expand_path('../../start', __FILE__)

describe "Ensure::Encoding, concerning cleanup of garbled input" do
  it "should be allowed to throw errors when not forced to drop invalid characters" do
    Dir.glob(File.expand_path('../../examples', __FILE__) + '/garbled*').each do |filename|
      text = read_example(filename)
      lambda {
        Ensure::Encoding.force_encoding(text, 'UTF-8')
      }.should.raise(Encoding::UndefinedConversionError)
    end
  end
  
  it "should not throw errors when forced to drop invalid characters" do
    Dir.glob(File.expand_path('../../examples', __FILE__) + '/garbled*').each do |filename|
      text = read_example(filename)
      lambda {
        Ensure::Encoding.force_encoding(text, 'UTF-8', :invalid_characters => :drop)
      }.should.not.raise
    end
  end
end