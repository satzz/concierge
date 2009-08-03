module MyFormat
  URL_PATTERN = "https?:\/\/[-_.!~*\'()a-zA-Z0-9;\/?:\@&=+\$,%#]+"
  REGEXP_FOR_LINK = Regexp.new("(?:\\[(#{URL_PATTERN}) *([^\\]]*)\\]|#{URL_PATTERN})")
  
  def my_format(text)
    puts text
    text = html_escape(text)
    text.gsub!(REGEXP_FOR_LINK) do |m|
      md = Regexp.last_match
      if m.match(/^\[/)
        if md[2].empty?
          %Q!<a href="#{md[1]}">! + md[1] + %Q!</a>!
        else
          %Q!<a href="#{md[1]}">! + md[2] + %Q!</a>!
        end
      else
        %Q!<a href="#{m}">! + m + %Q!</a>!
      end
    end
    text
  end
end
