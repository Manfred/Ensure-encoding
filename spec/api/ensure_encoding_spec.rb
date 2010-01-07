# encoding: utf-8

require File.expand_path('../../start', __FILE__)

describe "Ensure::Encoding, concerning force_encoding" do
  it "should change the encoding property of the string to the target encoding" do
    Ensure::Encoding.force_encoding('', 'UTF-8').encoding.should == Encoding::UTF_8
  end
  
  it "should return the string as-is when the encoding property is correct and equal to the target encoding" do
    example, data_in_utf8 = example('UTF-8')
    
    result = Ensure::Encoding.force_encoding(example, 'UTF-8')
    result.encoding.should == Encoding::UTF_8
    result.should == example
  end
  
  it "should only set the encoding property to the target encoding when the character data is already in the target encoding" do
    example, data_in_utf8 = example('UTF-8', :mark_as => 'ISO-8859-1')
    
    result = Ensure::Encoding.force_encoding(example, 'UTF-8')
    result.encoding.should == Encoding::UTF_8
    result.should == data_in_utf8
  end
  
  it "should transcode the character data when it's not in the target encoding" do
    example, data_in_utf8 = example('ISO-8859-1')
    
    result = Ensure::Encoding.force_encoding(example, 'UTF-8', :invalid_characters => :transcode)
    result.encoding.should == Encoding::UTF_8
    result.should == data_in_utf8
  end
  
  it "should raise an exception when the character data needs to be transcoded but is invalid" do
    example = [0x00, 0xff].pack('C*')
    example.force_encoding(Encoding::US_ASCII)
    
    lambda {
      Ensure::Encoding.force_encoding(example, 'UTF-8')
    }.should.raise(Encoding::InvalidByteSequenceError)
  end
end