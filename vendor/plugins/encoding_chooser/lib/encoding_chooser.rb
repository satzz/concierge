# encoding_chooser -- a plugin for Ruby on Rails

module EncodingChooser
  @@output_charset = 'utf-8'

  private
  def convert_input_encoding
    options = ''
    case @@output_charset
    when 'utf-8'
      options = '-m0 -Ww'
    when 'shift_jis'
      options = '-m0 -Sw'
    when 'euc-jp'
      options = '-m0 -Ew'
    else
      return
    end
    
    hash_conversion(params, options)
  end
  alias_method :convert_params_encoding, :convert_input_encoding
  
  def hash_conversion(hash, options)
    hash.each do |key, value|
      case value
      when Hash
        hash[key] = hash_conversion(value, options)
      when Array
        hash[key] = array_conversion(value, options)
      when String
        hash[key] = NKF.nkf(options, value)
      else
        hash[key] = value
      end
    end
    hash
  end

  def array_conversion(array, options)
    array.each_with_index do |value, i|
      case value
      when Hash
        array[i] = hash_conversion(value, options)
      when Array
        array[i] = array_conversion(value, options)
      when String
        array[i] = NKF.nkf(options, value)
      else
        array[i] = value
      end
    end
    array
  end
  
  def convert_output_encoding
    case @@output_charset
    when 'utf-8'
      options = '-wx'
    when 'shift_jis'
      options = '-sx'
    when 'euc-jp'
      options = '-ex'
    else
      return
    end

    headers["Content-Type"] = "text/html; charset=#{@@output_charset}"
    response.body = NKF.nkf(options, response.body)
    re = Regexp.new('<meta +http-equiv="content-type" +content="text/html; *charset=[\w\-]+" */?>', Regexp::IGNORECASE)
    str = %Q!<meta http-equiv="Content-Type" content="text/html; charset=#{@@output_charset}" />!
    response.body = response.body.gsub(re, str)
  end
  alias_method :convert_encoding, :convert_output_encoding
end


