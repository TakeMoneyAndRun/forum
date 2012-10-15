class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_url, :notice => "Logged in!"
    else
      render "new"
    end
  end

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def ban
    is_admin?

    @ban = Ban.new(params[:ban])
    @ban.expires_at = Time.now() + Integer(params[:time]).days
    @ban.user_id = params[:id]

    if @ban.save
      redirect_to :back, :notice => "Successfully banned"
    else
      flash[:error] = "Smth went wrong"
    end
  end

  def unban
   is_admin?
   @user = User.find(params[:id])
   @user.ban.destroy
   redirect_to :back, :notice => "Successfully unbanned"
  end

end
