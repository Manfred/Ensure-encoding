# encoding: utf-8

require File.expand_path('../../start', __FILE__)

describe "Ensure::Encoding, concerning force_encoding with default options" do
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
  
    result = Ensure::Encoding.force_encoding(example, 'UTF-8')
    result.encoding.should == Encoding::UTF_8
    result.should == data_in_utf8
  end

  it "should raise an exception when the character data needs to be transcoded but is invalid" do
    example = [0xc0, 0xf5].pack('C*').force_encoding(Encoding::UTF_8)
  
    lambda {
      Ensure::Encoding.force_encoding(example, 'ISO-8859-1', :external_encoding => Encoding::UTF_8)
    }.should.raise(Encoding::InvalidByteSequenceError)
  end
end

describe "Ensure::Encoding, concerning force_encoding with the external_encoding option" do
  it "should sniff encoding from the character data instead of relying on an explicitly specified encoding" do
    Ensure::Encoding.expects(:sniff_encoding).at_least(1).returns(Encoding::ISO_8859_1)
    
    example, data_in_utf8 = example('ISO-8859-1')
    result = Ensure::Encoding.force_encoding(example, Encoding::UTF_8, :external_encoding => :sniff)
    result.encoding.should == Encoding::UTF_8
    result.should == data_in_utf8
  end
  
  it "should guess the encoding from the character data by trying the specified external encodings" do
    example, data_in_utf8 = example('Shift_JIS')
    result = Ensure::Encoding.force_encoding(example, Encoding::UTF_8, :external_encoding => [
      Encoding::UTF_8, Encoding::Shift_JIS
    ])
    result.encoding.should == Encoding::UTF_8
    result.should == data_in_utf8    
  end
  
  it "should allow specifying exactly what the external encoding is" do
    example, data_in_utf8 = example('Shift_JIS', :mark_as => 'ISO-8859-1')
    result = Ensure::Encoding.force_encoding(example, Encoding::UTF_8, :external_encoding => Encoding::Shift_JIS)
    result.encoding.should == Encoding::UTF_8
    result.should == data_in_utf8
  end
end

describe "Ensure::Encoding, concerning force_encoding with the invalid_characters option" do
  before do
    @invalid_utf_8_and_utf_16 = [0xc0, 0xf5, 0x90].pack('C*').force_encoding(Encoding::UTF_16LE)
  end
  
  it "should raise an exception on invalid characters when asked to do so" do
    lambda {
      Ensure::Encoding.force_encoding(@invalid_utf_8_and_utf_16, 'UTF-8',
        :external_encoding => Encoding::UTF_16LE,
        :invalid_characters => :raise)
    }.should.raise(Encoding::InvalidByteSequenceError)
  end
  
  it "should drop invalid characters when asked to do so" do
    result = Ensure::Encoding.force_encoding(@invalid_utf_8_and_utf_16, 'UTF-8',
      :external_encoding => Encoding::UTF_16LE,
      :invalid_characters => :drop)
    result.valid_encoding?.should == true
    string_to_codepoints(result).should == ["0xf5c0"] # Random character in the private use area
  end
  
  it "should raise an exception on invalid characters when just asked to transcode" do
    lambda {
      Ensure::Encoding.force_encoding(@invalid_utf_8_and_utf_16, 'UTF-8',
        :external_encoding => Encoding::UTF_16LE,
        :invalid_characters => :transcode)
    }.should.raise(Encoding::InvalidByteSequenceError)
  end
end

describe "Ensure::Encoding, concerning force_encoding!" do
  it "should work just like force_encoding, only do an in-place replacement" do
    example, data_in_utf8 = example('ISO-8859-1')
    example.encoding.should == Encoding::ISO_8859_1
    
    result = Ensure::Encoding.force_encoding(example, 'UTF-8')
    example.encoding.should == Encoding::ISO_8859_1
    Ensure::Encoding.force_encoding!(example, 'UTF-8')
    result.should == example
  end
end