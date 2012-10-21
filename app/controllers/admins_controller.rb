class AdminsController < ApplicationController

  before_filter :authenticate_admin!

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.permission_level = 2

    if @user.save
      redirect_to root_url, :notice => "New admin created"
    else
      render "new"
    end
  end

  def promote
    @user=User.find(params[:user])
    @user.permission_level = 1
    @user.save

    redirect_to :back, :notice => "Successfully promoted"
  end

  def demote
    @user=User.find(params[:user])
    @user.permission_level = 0
    @user.save

    redirect_to :back, :notice => "Successfully demoted"
  end

end
