# encoding: utf-8

module Ensure
  module Encoding
    BYTE_ORDER_MARKS = {
      ::Encoding::UTF_16BE => [0xfe, 0xff],
      ::Encoding::UTF_16LE => [0xff, 0xfe],
      ::Encoding::UTF_8    => [0xef, 0xbb, 0xbf]
    }
    
    # Tries to guess the encoding of the string and returns the most likely
    # encoding.
    def self.sniff_encoding(string)
      first_bytes = string.unpack('C3')
      BYTE_ORDER_MARKS.each do |encoding, bytes|
        if first_bytes[0...bytes.length] == bytes
          return encoding
        end
      end
      ::Encoding::UTF_8
    end
    
    # Checks the encodings in +guesses+ from front to back and returns the
    # first encoding in which the character data is a valid sequence.
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
    
    # Forces the encoding of +string+ to +target_encoding+ and using a number
    # of smart tricks. See String#ensure_encoding for more details.
    def self.force_encoding(string, target_encoding, options={})
      target_string = string.dup
      force_encoding!(target_string, target_encoding, options)
      target_string
    end
    
    # Performs just like +force_encoding+, only it changes the string
    # in place instead of returning it.
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
        string.encode!(target_encoding, external_encoding, **filters)  # https://piechowski.io/post/last-arg-keyword-deprecated-ruby-2-7/
      end
    end
    
    module String
      # Ensures the character encoding in a string. It employs a number of
      # techniques to detect and transcode characters to make sure they end
      # up in a usuable form in the encoding you need.
      #
      # == Arguments
      #
      # +target_encoding+
      #   The character encoding you want to ensure; this is usually the
      #   internal encoding of your application. Accepts both string
      #   constants and encoding constants. (ie. 'UTF-8' or Encoding::UTF_8)
      # +options+
      #   Options to trigger activate certain algorithms.
      #
      # === Options
      #
      # :external_encoding
      #   Specifies both your certainty about the external encoding and what
      #   you think it might be. Valid options are :sniff, an array of
      #   encodings, or a single encoding. When you specify :sniff, we will
      #   sniff around in the data to guess which encoding it is. When you
      #   supply a list of possible encodings we will check them from begin
      #   to end if one of them matches the data. Finally, when you specify
      #   a specific encoding we assume you know which it is and we will use
      #   that. By default we use :external_encoding => [target_encoding,
      #   self.encoding].
      # :invalid_characters
      #   Specifies what to do with invalid characters. There are three valid
      #   values: :raise, :drop, and :transcode. The first raises and exception
      #   on an invalid character. The second will strip all invalid characters
      #   the last will try to transcode them to the wanted encoding. By default
      #   we transcode.
      #
      # == Example
      #
      #   response = REST.get('http://www.google.com')
      #
      #   if match = /charset=([^;]*)/.match(response.content_type)
      #     encoding = match[1]
      #   else
      #     encoding = 'UTF-8'
      #   end
      #
      #   body = response.body.ensure_encoding('UTF-8',
      #     :external_encoding => encoding,
      #     :invalid_characters => :drop)
      def ensure_encoding(target_encoding, options={})
        Ensure::Encoding.force_encoding(self, target_encoding, options)
      end
      
      # Performs just like String#ensure_encoding, only it changes the string
      # in place instead of returning it.
      def ensure_encoding!(target_encoding, options={})
        Ensure::Encoding.force_encoding!(self, target_encoding, options)
      end
    end
  end
end

class String
  include Ensure::Encoding::String
end
