# encoding: utf-8

module Ensure
  module Encoding
    VALID_PADDING = '  '.force_encoding(::Encoding::US_ASCII)
    
    def self.encoding_to_name(encoding)
      encoding.respond_to?(:name) ? encoding.name : encoding
    end
    
    def self.sniff_encoding(string)
      ::Encoding::UTF_8
    end
    
    def self.guess_encoding(string, guesses)
      original_encoding = string.encoding
      guessed_encoding = nil
      
      guesses.each do |guess|
        string.force_encoding(guess)
        if string.valid_encoding?
          guessed_encoding = string.encoding
          break
        end
      end
      
      string.force_encoding(original_encoding)
      guessed_encoding
    end
    
    def self.force_encoding!(string, target_encoding, options={})
      if options[:external_encoding] == :sniff
        external_encoding = sniff_encoding(string)
      else
        external_encoding = options[:external_encoding] || [target_encoding, string.encoding]
      end
      
      if external_encoding.respond_to?(:each)
        external_encoding = guess_encoding(string, external_encoding) || target_encoding
      end
      
      if options[:invalid_characters] == :raise
        string.force_encoding(target_encoding)
        raise ::Encoding::InvalidByteSequenceError, "String is not encoded as `#{target_encoding}'" unless string.valid_encoding?
      else
        filters = (options[:invalid_characters] == :drop) ? { :replace => '', :undef => :replace, :invalid => :replace } : {}
        string.encode!(target_encoding, external_encoding, filters)
      end
    end
    
    def self.force_encoding(string, target_encoding, options={})
      target_string = string.dup
      force_encoding!(target_string, target_encoding, options)
      target_string
    end
    
    module String
      def ensure_encoding(target_encoding, options={})
        Ensure::Encoding.force_encoding(self, target_encoding, options)
      end
    end
  end
end