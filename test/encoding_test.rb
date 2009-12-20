# encoding: utf-8

require 'rubygems'
require 'test/unit'
require 'active_support/test_case'

$:.unshift(File.expand_path('../../lib', __FILE__))
require 'encoding'

module EncodingTestHelpers
  def example(name, options={})
    example = ''
    File.open(File.expand_path("../examples/#{name}.txt", __FILE__), 'r:binary') do |file|
      example << file.read
    end
    example.force_encoding(options[:read_as] || Encoding::ASCII_8BIT)
  end
end

class EncodingTest < ActiveSupport::TestCase
  include EncodingTestHelpers
  
  test "source reports wrong encoding but is actually preferred encoding" do
    example = example('utf_8', :read_as => 'US-ASCII')
    example.ensure_encoding('UTF-8')
    assert_equal '℻', example
  end
  
  test "source has the wrong encoding but reports the correct encoding" do
    example = example('iso_8859_1', :read_as => 'ISO-8859-1')
    example.ensure_encoding('UTF-8')
    assert_equal 'Café', example
  end
  
  test "source has the wrong encoding and unjustly reports the target encoding" do
    example = example('iso_8859_1', :read_as => 'UTF-8')
    example.ensure_encoding('UTF-8')
    assert_equal 'Café', example
  end
  
  test "source has the wrong encoding and reports something different from its actual encoding" do
    example = example('iso_8859_1', :read_as => 'Shift_JIS')
    example.ensure_encoding('UTF-8')
    assert_equal 'Café', example
  end
end