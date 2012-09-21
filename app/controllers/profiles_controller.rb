class ProfilesController < ApplicationController
  def show
   is_user?
  end

  def edit
    is_user?
  end

  def update
    is_user?
    if current_user.update_attributes(params[:user])
      redirect_to :back, :notice => "Profile updated."

    else
      render "edit"
    end
  end

  def change_pass
    is_user?
    @user = current_user


    if  @user.password_valid?( params[:old_password])
      if params[:new_password].present?
        @user.password = params[:new_password]
        @user.password_confirmation =
            params[:new_password_confirmation]
        if @user.save

          redirect_to profile_url, :notice => "Your password has been changed"
        else
          redirect_to :back
          flash[:error] = 'Password does not match confirmation'
        end
      else
        redirect_to :back
        flash[:error] = 'Password can not be blank'
      end
    else
      redirect_to :back
      flash[:error] = 'Invalid password'
    end
  end
end
