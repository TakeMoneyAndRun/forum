class AdminsController < ApplicationController

  before_filter :authenticate_user!

  def new
    @user = User.new
  end

  def create
    if current_user.has_role? :admin
      @user = User.new(params[:user])
      @user.permission_level = 2

      if @user.save
        redirect_to root_url, :notice => "New admin created"
      else
        render "new"
      end
    else
      flash[:error] = "You have no permission"
      redirect_to :back
    end
  end


end
