class ForumsController < ApplicationController

  def index
    @forums = Forum.all
  end

  def new
    is_admin?
    @forum = Forum.new
  end

  def edit
    is_admin?
    @forum = Forum.find(params[:id])

  end

    def create
      is_admin?
    @forum = Forum.new(params[:forum])

    if @forum.save
      redirect_to :action => :index
    else
      render 'new'
    end

  end


  def update
    is_admin?
    @forum = Forum.find(params[:id])

    if @forum.update_attributes(params[:forum])
      redirect_to :action => :index
    else
      render 'edit'
    end

  end

  def destroy
    is_admin?
    @forum = Forum.find(params[:id])
    @forum.destroy

    redirect_to :action => :index
  end

  def search_posts
    @posts = Post.where("body LIKE '%#{params[:search]}%'")
  end
end
