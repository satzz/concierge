class Task < ActiveRecord::Base
  def self.search(params)
    condition = ['TRUE']
    if title = params[:title]
      condition[0] += ' AND title like ? '
      condition.push("%#{title}%")
    end
    if content = params[:content]
      condition[0] += ' AND content like ? '
      condition.push("%#{content}%")
    end
    if status = params[:status] and status != 'all'
      condition[0] += ' AND status = ? '
      condition.push(status)
    end
    if priority = params[:priority] and priority != 'all'
      condition[0] += ' AND priority = ? '
      condition.push(priority)
    end
    if assigner_id = params[:assigner_id] and assigner_id != 'all'
      condition[0] += ' AND assigner_id = ? '
      condition.push(assigner_id)
    end
    if owner_id = params[:owner_id] and owner_id != 'all'
      condition[0] += ' AND owner_id = ? '
      condition.push(owner_id)
    end
    puts condition
    param_sort = params[:sort]
    param_sort and param_sort.match(/id|title|content|owner_id|assigner_id|deadline|status|priority/) or param_sort = 'deadline'
    param_order = params[:order]
    param_order and param_order.match(/desc|asc/) or param_order = 'asc'
    Task.find(:all, :conditions => condition, :order => "#{param_sort} #{param_order}")
  end

  def owner
    Member.find(:first, :conditions =>['id = ?', owner_id])
  end

  def assigner
    Member.find(:first, :conditions =>['id = ?', assigner_id])
  end

  def color
    {
      3 => 'ff6666',
      2 => 'eeee33',
      1 => '33ee33',
      0 => 'cccccc',
    }[emergency]
  end

  def interval
    d = deadline
    t = Date.today
    puts d
    puts t
    hoge = d - t
    hoge
  end

  def emergency
    i = interval
    return 3 if i < 0
    return 2 if i < 30
    return 1 if i < 60
    return 0
  end
  
  def extended_priority
    (4-priority) * 100 + (id * 10) % 100
  end

  def font_size
    {
      1 => 8,
      2 => 12,
      3 => 16
    }[priority]
  end

  def div_str
    puts 'div_str'
    i = interval * 3
    return <<EOD
<div class="task" style="top:#{extended_priority}px; left:#{i}px; background-color:##{color};font-size:#{font_size}px;">
<a href="/tasks/show/#{id}">#{title}</a>
</div>
EOD
  end

  def update_by(params)
    update_attributes( { 
                         :title       => params[:title],
                         :content     => params[:content],
                         :owner_id    => params[:owner_id],
                         :assigner_id => params[:assigner_id],
                         :status      => params[:status],
                         :priority    => params[:priority],
                         :updated_at  => Time.now,
                       } )
  end


end
