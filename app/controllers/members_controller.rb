class MembersController < ApplicationController
  

  def set_members
    @members = Member.find(:all)
  end

  def index
    set_members
  end

  def show
    set_members
    @member = Member.find(params[:id])
    @message = params[:message]
  end

  def new
  end

  def edit
  end

  def create

  end

  def update
    member = Member.find(params[:id])
    member.update_by(params)
    message = member.errors.on(:phone)
    if message
      redirect_to :action => 'show', :id => params[:id], :message => message
    else
      redirect_to :action => 'index'
    end
  end

  def destroy
  end

end
