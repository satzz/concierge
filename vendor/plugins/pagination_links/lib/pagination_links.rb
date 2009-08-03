module PaginationLinks
  
  def my_pagination_links(paginator, options = nil)
    options = {} unless options
    options[:name] = 'page' unless options[:name]
    options[:window_size] = 5 unless options[:window_size]
    
    return '' unless paginator and paginator.length > 1
    
    s = ''
    if paginator.current.previous
      p = paginator.controller.params.dup
      p[options[:name]] = paginator.current.previous.first? ?
                        nil : paginator.current.previous
      s += link_to('前へ', p)
    else
      s += '<span class="disabled">前へ</span>'
    end
    s += '&nbsp;'
    
    pagination_numbers(paginator, options[:window_size]).each do |pn|
      s += ' '
      if pn == :gap
        s += '...'
      else
        page = paginator[pn]
        p = paginator.controller.params.dup
        p[options[:name]] = page.first? ? nil : page
        if p[options[:name]].to_i ==
             paginator.controller.params[options[:name]].to_i
          s += "<span class=\"current_page\">#{page.number}</span>"
        else
          s += link_to(page.number, p)
        end
      end
    end
    
    s += ' &nbsp;'
    if paginator.current.next
      p = paginator.controller.params.dup
      p[options[:name]] = paginator.current.next
      s += link_to('次へ', p)
    else
      s += '<span class="disabled">次へ</span>'
    end
  end
  
private
  def pagination_numbers(paginator, window_size)
    if window_size % 2 == 0
      left = window_size / 2 - 1
      right = window_size / 2
    else
      left = right = (window_size - 1) / 2
    end
    if paginator.current.number <= paginator.first.number + left
      ary = Range.new(1, window_size).to_a
    elsif paginator.current.number >= paginator.last.number - right
      ary = Range.new(paginator.last.number - window_size + 1, paginator.last.number).to_a
    else
      ary = Range.new(paginator.current.number - left, paginator.current.number + right).to_a
    end
    ary = ary.reject {|i| i < paginator.first.number or i > paginator.last.number }

    if ary[0] == paginator.first.number + 1
      ary.unshift(paginator.first.number)
    elsif ary[0] > paginator.first.number + 1
      ary[0, 1] = [paginator.first.number, :gap]
    end
    if ary[-1] == paginator.last.number - 1
      ary.push(paginator.last.number)
    elsif ary[-1] < paginator.last.number - 1
      ary[-1, 1] = [:gap, paginator.last.number]
    end
    ary
  end
end
