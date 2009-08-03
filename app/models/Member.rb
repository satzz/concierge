# -*- coding: utf-8 -*-
class Member < ActiveRecord::Base
  def full_name
    family_name + ' ' + given_name
  end

  def self.authenticate(login_name, password)
    member = find(:first,
                  :conditions => ["login_name = ?", login_name])
    if member and member.hashed_password == 
                    hashed_password(password, member.salt)
      member
    else
      nil
    end
  end

  def self.hashed_password(password, salt)
    Digest::SHA1.hexdigest(sprintf("%s%08d", password, salt))
  end

  def tasks
    Task.find(:all, :conditions => ['owner_id = ?', id])
  end

  def update_by(params)
    update_attributes({ 
                        :family_name => params[:family_name],
                        :given_name  => params[:given_name],
                        :furigana    => params[:furigana],
                        :email       => params[:email],
                        :phone       => params[:phone],
                        :updated_at  => Time.now,
                      })
  end

  def validate
    if phone && phone !~ /^¥d+(-¥d+)*$/
      errors.add(:phone, '電話番号の形式が正しくありません')
    end
  end
end
