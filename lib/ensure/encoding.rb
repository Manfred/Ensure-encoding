# encoding: utf-8

module Ensure
  module Encoding
    def self.force_encoding!(string, target_encoding, options=[])
      target_encoding = ::Encoding.find(target_encoding)
      
      # Don't do anything if it's already encoded in the target encoding
      return if (target_encoding == string.encoding) and string.valid_encoding?
      
      reported_encoding = string.encoding
      
      # Change the encoding property if that's the only thing incorrect
      string.force_encoding(target_encoding)
      return string if string.valid_encoding?
      
      # Assume the reported encoding was correct and transcode
      begin
        string.force_encoding(reported_encoding)
        string.encode!(target_encoding)
        return
      rescue ::Encoding::InvalidByteSequenceError, ::Encoding::UndefinedConversionError
      end
      
      raise ::Encoding::InvalidByteSequenceError, "Can't ensure preferred encoding `#{target_encoding}'"
    end
    
    def self.force_encoding(string, target_encoding, options=[])
      target_string = string.dup
      force_encoding!(target_string, target_encoding, options)
      target_string
    end
    
    module String
      def ensure_encoding(target_encoding, options=[])
        Ensure::Encoding.force_encoding(self, target_encoding, options)
      end
    end
  end
end