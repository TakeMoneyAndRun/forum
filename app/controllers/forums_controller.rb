class ForumsController < ApplicationController

  before_filter :authenticate_admin!, :except => [:index, :search_posts]

  def index
    @forums = Forum.all
  end

  def new
    @forum = Forum.new
  end

  def edit
    @forum = Forum.find(params[:id])
  end

  def create
    @forum = Forum.new(params[:forum])

    if @forum.save
      redirect_to :action => :index
    else
      render 'new'
    end
  end

  def update
    @forum = Forum.find(params[:id])

    if @forum.update_attributes(params[:forum])
      redirect_to :action => :index
    else
      render 'edit'
    end
  end

  def destroy
    @forum = Forum.find(params[:id])
    @forum.destroy

    redirect_to :action => :index
  end

  def search_posts
    @posts = Post.where("body LIKE '%#{params[:search]}%'")
  end

end
