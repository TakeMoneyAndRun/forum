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
    # все норм, но проблема с полем expires_at. Видимо из-за формата time, к нему наверн особый подход нужен.
    # Пробовал разные варианты, хочу вот через селект сделатьв стиле expires_at = Time.now + Integer(params[:time]).days
    # но в итоге expires_at ставится на 2000-01-01 + текущее время.
    is_admin?
    @ban = Ban.new(params[:ban])
    @ban.expires_at = Time.now() + 12.years
    @ban.user_id = params[:id]
    if @ban.save
    redirect_to :back, :notice => "Successfully banned"
    else
    flash[:error] = "Smth went wrong"
    end
  end

end
