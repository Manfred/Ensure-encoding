# encoding: utf-8

module Ensure
  module Encoding
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
      internal_encoding = ::Encoding.find(target_encoding)
      
      if options[:external_encoding] == :sniff
        external_encoding = sniff_encoding(string)
      else
        external_encoding = options[:external_encoding] || [internal_encoding, string.encoding]
      end
      
      if external_encoding.respond_to?(:each)
        external_encoding = guess_encoding(string, external_encoding) || internal_encoding
      end
      
      case options[:invalid_characters]
      when :raise
        string.force_encoding(internal_encoding)
        raise ::Encoding::InvalidByteSequenceError, "String is not encoded as `#{internal_encoding}'" unless string.valid_encoding?
      when :drop
        string.force_encoding(external_encoding)
        string.encode!(internal_encoding, 'something')
      else # :transcode
        string.force_encoding(external_encoding)
        string.encode!(internal_encoding)
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