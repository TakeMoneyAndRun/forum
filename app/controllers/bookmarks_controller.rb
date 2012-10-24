class BookmarksController < ApplicationController

  def create
    authenticate_user!

    @bookmark = Bookmark.new(params[:bookmark])
    @bookmark.user = current_user
    @bookmark.topic = Topic.find(params[:topic])

    if @bookmark.save
      redirect_to :back, :notice => "Bookmark added"
    else
      flash[:error] = "Smth went wrong"
      redirect_to :back
    end
  end

  def destroy
    authenticate_user!

    @bookmark = Bookmark.find(params[:id])

    unless logged?(@bookmark.user_id) || admin?
      flash[:error] = 'You dont have access to this page'
      redirect_to root_url
    end

    @bookmark.destroy
    redirect_to :back
  end

end
