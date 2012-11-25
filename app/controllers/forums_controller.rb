class ForumsController < ApplicationController

  load_and_authorize_resource

  def index

  end

  def new

  end

  def edit

  end

  def create


    if @forum.save
      redirect_to :action => :index
    else
      render 'new'
    end
  end

  def update


    if @forum.update_attributes(params[:forum])
      redirect_to :action => :index
    else
      render 'edit'
    end
  end

  def destroy

    @forum.destroy

    redirect_to :action => :index
  end

  def search_posts
    @posts = Post.where("body LIKE '%#{params[:search]}%'")
  end

end
