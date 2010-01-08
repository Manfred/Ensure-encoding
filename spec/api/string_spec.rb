# encoding: utf-8

require File.expand_path('../../start', __FILE__)

describe "String, extended with Ensure::Encoding::String" do
  it "should respond to ensure_encoding" do
    ''.respond_to?(:ensure_encoding).should == true
  end
  
  it "should respond to ensure_encoding!" do
    ''.respond_to?(:ensure_encoding!).should == true
  end
  
  it "should force encoding to the encoding specified" do
    example = 'Café'
    
    result = example.ensure_encoding('ISO-8859-1')
    result.encoding.should == Encoding::ISO_8859_1
    
    example.ensure_encoding!('ISO-8859-1')
    example.encoding.should == Encoding::ISO_8859_1
  end
end