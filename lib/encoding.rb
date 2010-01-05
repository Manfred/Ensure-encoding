# encoding: utf-8

class String
  def ensure_encoding(target_encoding)
    target_encoding = Encoding.find(target_encoding)
    
    # Don't do anything if it's already encoded in the target encoding
    return if (target_encoding == encoding) and valid_encoding?
    
    # Change the encoding property if that's the only thing incorrect
    reported_encoding = encoding
    force_encoding(target_encoding)
    return if valid_encoding?    
    
    # Assume the reported encoding was correct and transcode
    begin
      force_encoding(reported_encoding)
      encode!(target_encoding)
      return
    rescue Encoding::InvalidByteSequenceError, Encoding::UndefinedConversionError
    end
    
    raise Encoding::InvalidByteSequenceError, "Can't ensure preferred encoding `#{target_encoding}'"
  end
end