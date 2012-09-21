class PostsController < ApplicationController
  def new
    is_user?
   @forum = Forum.find(params[:forum_id])
   @topic = Topic.find(params[:topic_id])
   @post = @topic.posts.build
  end

  def create
    is_user?

    if Topic.exists?(params[:topic_id])
      @forum = Forum.find(params[:forum_id])
      @topic = Topic.find(params[:topic_id])
      @post = @topic.posts.build(params[:post])
      @post.user = current_user
    else
      redirect_to(forums_path, :notice =>"Please specify a valid forum")
    end

    if current_user && @post.save
      redirect_to(forum_topic_path(@forum,@topic), :notice => 'Your reply was posted')
    else
      render 'new'
    end
  end

  def edit
    @post = Post.find_by_id(params[:id])
    @topic = @post.topic
    @forum=@topic.forum
    unless owner?(@post.user.id) || moderator? || admin?
      redirect_to root_url
      flash[:error] = 'You dont have access to this page'
    end
  end

  def update
    @post = Post.find_by_id(params[:id])

    unless owner?(@post.user.id) || moderator? || admin?
      redirect_to root_url
      flash[:error] = 'You dont have access to this page'
    end

    if @post.update_attributes(params[:post])
      redirect_to forum_topic_path(params[:forum_id], params[:topic_id])
    else
      render 'edit'
    end
  end

  def destroy
    is_admin?
    @post = Post.find(params[:id])
    @post.body = 'Deleted by admin'
    @post.save

    redirect_to forum_topic_path(params[:forum_id], params[:topic_id])
  end
end
