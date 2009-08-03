# -*- coding: utf-8 -*-
class LoginController < ApplicationController
  verify :method => :post,
         :only => [ :login ],
         :redirect_to => { :controller => 'main', :action => 'index' }
  
  def login
    login_name = params[:login_name]
    password = params[:password]
    member = Member.authenticate(login_name, password)
    if member
      session[:member_id] = member.id
    else
      session[:member_id] = nil
      flash[:warning] = 'ログイン失敗'
      flash[:login_name] = login_name
    end
    if params[:from]
      redirect_to params[:from]
    else
      redirect_to :controller => 'main', :action => 'index'
    end
  end
  
  def logout
    session[:member_id] = nil
    redirect_to :controller => 'tasks', :action => 'index'
  end
end
