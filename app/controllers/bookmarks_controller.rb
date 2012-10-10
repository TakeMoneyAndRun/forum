class BookmarksController < ApplicationController

  def create
    is_user?
    @bookmark = Bookmark.new(params[:bookmark])
    @bookmark.user = current_user
    @bookmark.topic = Topic.find(params[:topic])

    if @bookmark.save
      redirect_to :back, :notice => "Bookmark added"
    end
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    unless owner?(@bookmark.user.id) || admin?
      redirect_to root_url
      flash[:error] = 'You dont have access to this page'
    end
    @bookmark.destroy
    redirect_to :back
  end

end
