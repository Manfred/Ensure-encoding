# encoding: utf-8

require 'rubygems' rescue LoadError
require 'bacon'
require 'mocha-on-bacon' # https://github.com/alloy/mocha-on-bacon

require 'fileutils'

$:.unshift(File.expand_path('../../lib', __FILE__))

require 'ensure/encoding'

module EncodingTestHelpers
  EXAMPLES = {
    'UTF-8'      => 'पशुपतिरपि तान्यहानि कृच्छ्राद्',
    'ISO-8859-1' => 'Prévisions météo de Météo-France',
    'Shift_JIS'  => 'こんにちは',
    'UTF-16LE'   => 'Ἰοὺ ἰού· τὰ πάντʼ ἂν ἐξήκοι σαφῆ.',
    'UTF-16BE'   => 'По оживлённым берегам'
  }
  
  def examples
    EXAMPLES.keys
  end
  
  def read_example(filename)
    contents = ''
    File.open(filename, 'r:binary') do |file|
      contents << file.read
    end
    contents
  end
  
  def example(name, options={})
    filename, contents = name.gsub(/-/, '_').downcase, ''
    contents = read_example(File.expand_path("../examples/#{filename}.txt", __FILE__))
    contents.force_encoding(options[:mark_as] || Encoding.find(name))
    return contents, EXAMPLES[name]
  end
  
  def integer_array_to_hex(ints)
    ints.map { |i| "0x#{i.to_s(16)}" }
  end
  
  def string_to_bytes(string)
    integer_array_to_hex string.unpack('C*')
  end
  
  def string_to_codepoints(string)
    integer_array_to_hex string.unpack('U*')
  end
end

class Bacon::Context
  include EncodingTestHelpers
end

Bacon.extend Bacon::TestUnitOutput
Bacon.summary_on_exit
