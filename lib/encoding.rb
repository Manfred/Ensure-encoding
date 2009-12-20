# encoding: utf-8

class String
  ENCODING_GUESSES = [Encoding::UTF_8, Encoding::ISO_8859_1, Encoding::ASCII_8BIT]
  
  def ensure_encoding!(target_encoding)
    target_encoding = Encoding.find(target_encoding)
    
    force_encoding(target_encoding)
    return if valid_encoding?
    
    ENCODING_GUESSES.each do |guess|
      begin
        force_encoding(guess)
        encode(target_encoding)
        return
      rescue Encoding::InvalidByteSequenceError, Encoding::UndefinedConversionError
      end
    end
    
    raise Encoding::InvalidByteSequenceError, "Can't ensure preferred encoding `#{target_encoding}'"
  end
end