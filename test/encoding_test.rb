# encoding: utf-8

require 'rubygems'
require 'test/unit'
require 'active_support/test_case'

$:.unshift(File.expand_path('../../lib', __FILE__))
require 'encoding'

module EncodingTestHelpers
  EXAMPLES = {
    'UTF-8'      => 'पशुपतिरपि तान्यहानि कृच्छ्राद्',
    'ISO-8859-1' => 'Prévisions météo de Météo-France',
    'Shift_JIS'  => 'こにちわ'
  }
  
  def examples
    EXAMPLES.keys
  end
  
  def example(name, options={})
    filename, contents = name.gsub(/-/, '_').downcase, ''
    File.open(File.expand_path("../examples/#{filename}.txt", __FILE__), 'r:binary') do |file|
      contents << file.read
    end
    contents.force_encoding(options[:read_as] || Encoding::ASCII_8BIT)
    return contents, EXAMPLES[name]
  end
end

class EnsureEncodingTest < ActiveSupport::TestCase
  include EncodingTestHelpers
  
  test "string has wrong encoding property but preferred encoding data" do
    (Encoding.list - [Encoding::UTF_8]).each do |source_encoding|
      (examples - [source_encoding]).each do |e|
        source, expected = example(e, :read_as => source_encoding)
        source.ensure_encoding(e)
        
        message = "When testing with encoding property #{source_encoding}, having #{e} data"
        assert_equal(Encoding.find(e), source.encoding, message)
        assert_equal(expected.encode(e), source, message)
      end
    end
  end
  
  test "string doesn't have the preferred encoding but properly reports its own encoding" do
    # All examples can be transcoded to UTF-8 without loss
    (examples - ['UTF-8']).each do |e|
      source, expected = example(e, :read_as => e)
      source.ensure_encoding('UTF-8')
      
      message = "When testing with encoding property #{e}, having #{e} data"
      assert_equal(Encoding::UTF_8, source.encoding, message)
      assert_equal(expected, source, message)
    end
  end
  
  test "string data is not in the target encoding but the encoding property says it does" do
    (examples - ['UTF-8']).each do |e|
      source, expected = example(e, :read_as => 'UTF-8')
      source.ensure_encoding('UTF-8')
      
      message = "When testing with encoding property UTF-8, having #{e} data"
      assert_equal(Encoding::UTF_8, source.encoding, message)
      # Note that this probably results in a string that doesn't display properly because we
      # can't differentiate between two encodings (ie. Latin-1 and UTF-8) in a lot of cases.
    end
  end

  test "string doesn't have the preferred encoding and improperly reports its own encoding" do
    (examples - ['UTF-8']).each do |e|
      source, expected = example(e, :read_as => Encoding::KOI8_R)
      source.ensure_encoding('UTF-8')
      
      message = "When testing with encoding property UTF-8, having #{e} data"
      assert_equal(Encoding::UTF_8, source.encoding, message)
      # Note that this probably results in a string that doesn't display properly because we
      # can't differentiate between two encodings (ie. Latin-1 and UTF-8) in a lot of cases.
    end
  end
  
  test "string has junk and we can't do anything with it" do
    assert_raises(Encoding::InvalidByteSequenceError) do
      example = [0x00, 0xff].pack('C*')
      example.force_encoding(Encoding::US_ASCII)
      example.ensure_encoding('UTF-8')
    end
  end
end

class SniffEncodingTest < ActiveSupport::TestCase
  include EncodingTestHelpers
  
  test "properly sniffs encoding for a number of examples" do
    ['UTF-8', 'UTF-16LE', 'UTF-16BE'].each do |e|
      source, _ = example(e, :read_as => Encoding::US_ASCII)
      assert_equal(Encoding.find(e), source.sniffed_encoding)
    end
  end
end