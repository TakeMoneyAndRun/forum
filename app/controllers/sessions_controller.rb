class SessionsController < ApplicationController

  def new
    session[:return_to] = request.referer
  end

  def create
    user = User.authenticate(params[:email], params[:password])

    if user
      if user.ban.present?
        if user.ban.expires_at > DateTime.now.to_date
          flash.now.alert = "You are banned till #{user.ban.expires_at}. Reason: #{user.ban.reason}"
          render "new"
        else
          user.ban.destroy
          new_session(user)
        end
      else
        new_session(user)
      end
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end

  protected

  def new_session(user)
    session[:user_id] = user.id

    if session[:return_to].present?
      redirect_to session[:return_to]
    else
      redirect_to root_url
    end

    session[:return_to] = nil
  end

end


