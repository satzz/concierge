require 'date'

# Date クラスに対する拡張
# 
# ActiveRecord のオブジェクトに対し、存在しない日付を含むパラメータを
# attributes = params[:object] の形で与えると例外が発生するが、
# どのフィールドに不正な値が入力されたのかを判定できない。
# この問題を解決するため、存在しない日付で Date クラスを
# インスタンス化でき、また is_valid? メソッドで調べられるようにした。
class Date
  attr_accessor :dummy
  
  class << self
    alias_method :original_civil, :civil
    
    # 有効な日付ならオリジナルの civil メソッドを呼び、
    # そうでなければインスタンス変数 dummy に日付を格納する。
    def civil(y=-4712, m=1, d=1, sg=ITALY)
      if valid_civil?(y, m, d, sg)
        original_civil(y, m, d, sg)
      else
        date = Date.new
        date.dummy = { :year => y, :month => m, :day => d }
        date
      end
    end
    
    # オリジナルの Date クラス同様に、new メソッドをエイリアスする。
    alias_method :new, :civil
  end
  
  # メソッド year, month, day をオーバーライドする。
  def year() dummy ? dummy[:year].to_i : civil[0] end
  def month() dummy ? dummy[:month].to_i : civil[1] end
  def day() dummy ? dummy[:day].to_i : civil[2] end

  # このインスタンスが、有効な(存在する)日付を保持しているかどうか
  # を boolean 値で返す。
  def is_valid?() dummy.nil? end
  
  # フォーマットを指定しない場合、'2000-02-28' の
  # 形式で文字列に変換するように、to_s をオーバーライドする。
  # 
  # 指定できるフォーマットについては、
  #   active_support/core_ext/date/conversions.rb
  # を参照のこと。
  alias_method :active_support_original_to_s, :to_s
  def to_s(format = nil)
    # ActiveSupport を require していない場合は、to_s の引数の個数は 0
    if method(:active_support_original_to_s).arity == 0
      strftime("%Y-%m-%d")
    else
      format ? active_support_original_to_s(format) : strftime("%Y-%m-%d")
    end
  end
end
