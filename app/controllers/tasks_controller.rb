# -*- coding: utf-8 -*-
require 'pp'
class TasksController < ApplicationController
  def set_members
    @members = Member.find(:all)
  end
  
  def index
    set_members

    if params[:add]
      redirect_to ({
                     :action      => 'new', 
                     :title       => params[:title],
                     :content     => params[:content],
                     :owner_id    => params[:owner_id],
                     :assigner_id => params[:assigner_id],
                     :status      => params[:status],
                     :priority    => params[:priority],
                   })
    else
      @tasks = Task.search(params)
      @div_str = @tasks.map{|task| task.div_str}.join
      recent_task_changes = Task.find(:all, :order => 'updated_at DESC',  :limit => 5).map {|task| "#{task.updated_at} <a href='/tasks/show/#{task.id}'>タスク##{task.id}</a>が更新されました"}
      recent_member_changes = Member.find(:all, :order => 'updated_at DESC',  :limit => 5).map {|member| "#{member.updated_at} <a href='/members/show/#{member.id}'>メンバー情報##{member.id}</a>が更新されました"}
      @recent_changes = [recent_task_changes,recent_member_changes].flatten.sort
      @message = params[:message]
    end
  end

  def show
    set_members
    @task = Task.find(params[:id])
    @statuses = ['new', 'open', 'closed', 'invalid', 'suspended']
    @priorities = [1, 2, 3]
  end

  def new
    Task.new({
      :title       => params[:title],
      :content     => params[:content],
      :owner_id    => params[:owner_id],
      :assigner_id => params[:assigner_id],
      :status      => params[:status],
      :priority    => params[:priority],
      :deadline    => params[:deadline] || Date.today,
    }).save
    redirect_to :action => 'index'
  end

  def edit
  end

  def create

  end

  def update
    task = Task.find(params[:id])
    task.update_by(params)
    redirect_to :action => 'index'
  end

  def destroy
    id =  params[:id]
    Task.destroy(params[:id])
    redirect_to :action => 'index', :message => "タスク##{id}を削除しました"
  end

end
