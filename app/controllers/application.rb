# -*- coding: utf-8 -*-
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  session :session_key => '_asagao_session_id'
  
  before_filter :resume_session
  
  private
  # セッションの再開
  def resume_session
    return unless session[:member_id]
    
    begin
      @current_user = Member.find(session[:member_id])
    rescue ActiveRecord::RecordNotFound
      session[:member_id] = nil
    end
  end
  
  # ログインしていないユーザーをはじく
  def block_non_members
    unless @current_user
      flash[:warning] = 'ログインが必要です。'
      redirect_to :controller => '/main', :action => 'index'
      return false
    end
  end
  
  # 例外処理
  def rescue_action_in_public(exception)
    case exception
    when ActiveRecord::RecordNotFound
      if request.get?
        render :template => 'shared/404', :status => '404 Not Found'
      else
        redirect_to :action => 'index'
      end
    else
      raise exception
    end
  end
end
