# encoding: utf-8

require 'rubygems'
require 'test/unit'
require 'active_support/test_case'

$:.unshift(File.expand_path('../../lib', __FILE__))
require 'encoding'

module EncodingTestHelpers
  EXAMPLES = {
    'UTF-8'      => '℻',
    'UTF-16LE'   => '☺',
    'UTF-16BE'   => '☺',
    'ISO-8859-1' => 'Café',
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

class EncodingTest < ActiveSupport::TestCase
  include EncodingTestHelpers
  
  test "source reports wrong encoding but is actually preferred encoding" do
    (Encoding.list - [Encoding::UTF_8]).each do |source_encoding|
      examples.each do |e|
        source, expected = example(e, :read_as => source_encoding)
        source.ensure_encoding('UTF-8')
        assert_equal(expected, source, "When testing example #{e}, with source encoding #{source_encoding}")
      end
    end
  end
  
  test "source has the wrong encoding but properly reports its own encoding" do
    (examples - ['UTF-8']).each do |e|
      source, expected = example(e, :read_as => e)
      source.ensure_encoding('UTF-8')
      assert_equal(expected, source, "When testing example #{e}")
    end
  end
  
  test "source has the wrong encoding and unjustly reports the target encoding" do
    (examples - ['UTF-8']).each do |e|
      source, expected = example(e, :read_as => 'UTF-8')
      source.ensure_encoding('UTF-8')
      assert_equal(expected, source, "When testing example #{e}")
    end
  end
  
  test "source has the wrong encoding and reports something different from its actual encoding" do
    (examples - ['UTF-8']).each do |e|
      source, expected = example(e, :read_as => Encoding::KOI8_R)
      source.ensure_encoding('UTF-8')
      assert_equal(source, expected, "When testing example #{e}")
    end
  end
end