class AdminsController < ApplicationController
  def new
    is_admin?
    @user = User.new
  end

  def create
    is_admin?
    @user = User.new(params[:user])
    @user.permission_level = 2
    if @user.save
        redirect_to root_url, :notice => "New admin created"
    else
      render "new"
    end
  end

  def promote
    is_admin?
   @user=User.find(params[:user])
   @user.permission_level = 1
   @user.save
    redirect_to :back, :notice => "Successfully promoted"
  end

  def demote
    is_admin?
    @user=User.find(params[:user])
    @user.permission_level = 0
    @user.save
    redirect_to :back, :notice => "Successfully demoted"
  end
end
