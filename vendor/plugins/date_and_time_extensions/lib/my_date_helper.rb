module MyDateHelper
  def my_date_select(object_name, method, options={})
    object = instance_variable_get("@#{object_name.to_s}")
    time = object.send(method.to_sym)
    
    options[:use_month_numbers] = true if options[:use_month_numbers].nil?
    options.merge!(:prefix => object_name.to_s)
    
    tags  = select_year(time,
              options.merge(:field_name => "#{method}(1i)")) + '年 '
    tags += select_month(time,
              options.merge(:field_name => "#{method}(2i)")) + '月 '
    tags += select_day(time,
              options.merge(:field_name => "#{method}(3i)")) + '日 '
    
    object.errors.on(method) ? field_error_proc.call(tags, self) : tags
  end
  
  def my_datetime_select(object_name, method, options={})
    object = instance_variable_get("@#{object_name.to_s}")
    time = object.send(method.to_sym)
    
    options[:use_month_numbers] = true if options[:use_month_numbers].nil?
    options.merge!(:prefix => object_name.to_s)
    
    tags  = select_year(time,
              options.merge(:field_name => "#{method}(1i)")) + '年 '
    tags += select_month(time,
              options.merge(:field_name => "#{method}(2i)")) + '月 '
    tags += select_day(time,
              options.merge(:field_name => "#{method}(3i)")) + '日 '
    tags += select_hour(time,
              options.merge(:field_name => "#{method}(4i)")) + '時 '
    tags += select_minute(time,
              options.merge(:field_name => "#{method}(5i)")) + '分 '
    if options[:include_seconds]
      tags += select_second(time,
        options.merge(:field_name => "#{method}(6i)")) + '秒'
    end
    
    object.errors.on(method) ? field_error_proc.call(tags, self) : tags
  end
end
