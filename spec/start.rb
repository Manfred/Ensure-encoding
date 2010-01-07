# encoding: utf-8

require 'rubygems' rescue LoadError
require 'test/spec'
require 'mocha'

require 'fileutils'

$:.unshift(File.expand_path('../../lib', __FILE__))

require 'ensure'
require 'core_ext'


module EncodingTestHelpers
  EXAMPLES = {
    'UTF-8'      => 'पशुपतिरपि तान्यहानि कृच्छ्राद्',
    'ISO-8859-1' => 'Prévisions météo de Météo-France',
    'Shift_JIS'  => 'こにちわ',
    # 'UTF-16LE'   => '',
    # 'UTF-16BE'   => ''
  }
  
  def examples
    EXAMPLES.keys
  end
  
  def example(name, options={})
    filename, contents = name.gsub(/-/, '_').downcase, ''
    File.open(File.expand_path("../examples/#{filename}.txt", __FILE__), 'r:binary') do |file|
      contents << file.read
    end
    contents.force_encoding(options[:mark_as] || Encoding.find(name))
    return contents, EXAMPLES[name]
  end
end

class Test::Unit::TestCase
  include EncodingTestHelpers
end