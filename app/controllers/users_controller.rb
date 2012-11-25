class UsersController < ApplicationController

 before_filter :authenticate_user!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def ban
    @user = User.find(params[:id])

    if !@user.ban && current_user.has_role?(:admin) && !@user.has_role?(:admin)
      @ban = Ban.new(params[:ban])
      @ban.expires_at = Time.now() + Integer(params[:time]).days
      @ban.user_id = @user.id

      if @ban.save
        redirect_to :back, :notice => "Successfully banned"
       else
        flash[:error] = "Smth went wrong"
       end
    else
      flash[:error] = "You can't ban this user'"
      redirect_to root_url
    end
  end

  def unban
    @user = User.find(params[:id])

    if @user.ban && current_user.has_role?(:admin)
       @user.ban.destroy
      redirect_to :back, :notice => "Successfully unbanned"
    else
      flash[:error] = "You can't unban this user'"
      redirect_to root_url
    end
  end


 def promote
   @user = User.find(params[:id])

   if  current_user.has_role?(:admin) && @user.has_role?(:user) && !@user.has_role?(:moderator)

      @role = UsersRole.new(:user_id => @user.id, :role_id => 2 )

      if @role.save
        redirect_to :back, :notice => "Successfully promoted"
      else
        flash[:error] = "Smth went wrong"
        redirect_to :back
     end

   else
     flash[:error] = "You can't promote this user'"
     redirect_to root_url
   end


 end

 def demote
   @user = User.find(params[:id])

 if  current_user.has_role?(:admin) && @user.has_role?(:moderator)


   @role = UsersRole.find_by_user_id_and_role_id(@user.id, 2)

   if @role && @role.destroy
     redirect_to :back, :notice => "Successfully demoted"
   else
     flash[:error] = "Smth went wrong"
     redirect_to :back
   end

 else
    flash[:error] = "You can't demote this user'"
    redirect_to root_url
 end

end

end
