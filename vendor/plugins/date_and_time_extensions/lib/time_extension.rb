require 'date'

# Time クラスに対する拡張
# 
# Time クラスは、「2000年2月30日00時00分」のような存在しない
# 日付でインスタンス化しても例外を発生させない。例えば
# t = Time.local(2000, 2, 30) とすれば、「2000年3月1日」として
# 認識される。
# 
# 拡張された Time クラスでは、上記の例において t.month、
# t.day は 2 および 30 を返し、t.is_valid? が false を返す。
# 
# この拡張の目的は、ActiveRecord の検証機構において不正な
# 日付を検出できるようにすることである。
# 
# def validate
#   if birthday and !birthday.is_valid?
#     errors.add(:birthday, 'の日付が正しくありません。')
#   end
# end
class Time
  attr_accessor :dummy

  class << self
    alias_method :orig_utc, :utc
    def utc(y, m=1, d=1, h=0, min=0, s=0, usec=0)
      time = orig_utc(y, m, d, h, min, s)
      time.dummy = make_dummy(y, m, d, h, min, s)
      time
    end
 
    alias_method :orig_local, :local
    def local(y, m=1, d=1, h=0, min=0, s=0, usec=0)
      time = orig_local(y, m, d, h, min, s)
      time.dummy = make_dummy(y, m, d, h, min, s)
      time
    end
    
    private
    def make_dummy(y, m=1, d=1, h=0, min=0, s=0, usec=0)
      unless Date.valid_civil?(y, m, d) and DateTime.valid_time?(h, min, s)
        { :year => y, :month => m, :day => d,
          :hour => h, :min => min, :sec => s, :usec => usec }
      end
    end
  end

  # year, month, day, hour, min, sec をオーバーライドする
  # 'year' の部分を置き換えながら次の2行を6回繰り返すのと同じ。
  #   alias :orig_year :year
  #   def year; dummy ? dummy[:year] : orig_year end
  %w(year month day hour min sec).each do |method_name|
    class_eval <<-end_eval
      alias_method :orig_#{method_name}, :#{method_name}
      def #{method_name}
        dummy ? dummy[:#{method_name}] : orig_#{method_name}
      end
    end_eval
  end

  # このインスタンスが、有効な(存在する)日付を保持しているかどうか
  # を boolean 値で返す。
  def is_valid?() dummy.nil? end
  
  # デフォルト(フォーマットを指定しない場合)で、'2000-02-28 00:00:00' の
  # 形式で文字列に変換する。
  # 
  # 指定できるフォーマットについては、
  #   active_support/core_ext/time/conversions.rb
  # を参照のこと。
  alias_method :active_support_original_to_s, :to_s
  def to_s(format=:db)
    # ActiveSupport を require していない場合は、to_s の引数の個数は 0
    if method(:active_support_original_to_s).arity == 0
      strftime("%Y-%m-%d %H:%M:%S")
    else
      active_support_original_to_s(format)
    end
  end
end
