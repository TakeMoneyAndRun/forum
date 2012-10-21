class PostsController < ApplicationController

  before_filter :authenticate_user!

  def new
    @forum = Forum.find(params[:forum_id])
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.build
  end

  def create
    if Topic.exists?(params[:topic_id])

      @forum = Forum.find(params[:forum_id])
      @topic = Topic.find(params[:topic_id])
      @post = @topic.posts.build(params[:post])
      @post.user = current_user

      if params[:reply]
        @post.note = false
      end

      if params[:note]
        @post.note = true
      end

    else
      redirect_to(forums_path, :notice =>"Please specify a valid forum")
    end

    if @post.save
      redirect_to(forum_topic_path(@forum,@topic), :notice => 'Your reply was posted')
    else
      render 'new'
    end
  end

  def edit
    @post = Post.find_by_id(params[:id])

    unless logged?(@post.user.id) || moderator? || admin?
      flash[:error] = 'You dont have access to this page'
      redirect_to root_url
    end

    @topic = @post.topic
    @forum =  @topic.forum

  end

  def update
    @post = Post.find_by_id(params[:id])

    unless logged?(@post.user.id) || moderator? || admin?
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
    @post = Post.find(params[:id])

    if logged?(@post.user.id) || moderator? || admin?
      @post.body = 'Deleted'
      @post.save
      redirect_to forum_topic_path(params[:forum_id], params[:topic_id])
    else
      redirect_to root_url
      flash[:error] = 'You dont have access to this action'
    end
  end

  def vote
    # можно вынести в отдельный метод
    @post = Post.find(params[:id])

    unless Vote.where('user_id = ? AND post_id = ?', current_user.id, @post.id).exists?
      @post.increment(:rating)
      @post.save

      @vote = Vote.new(params[:vote])
      @vote.user = current_user
      @vote.post = @post
      @vote.save

      redirect_to :back, :notice => "Voted successfully"
    else
     flash[:error] = "Sorry, you have already voted"
     redirect_to :back
    end
  end

  def complain
    @post = Post.find(params[:id])
    unless Complain.where('user_id = ? AND post_id = ?', current_user.id, @post.id).exists?
      @post.complained = true
      @post.save

      @complain = Complain.new(params[:complain])
      @complain.user = current_user
      @complain.post = @post
      @complain.save

      redirect_to :back, :notice => "Complained successfully"
    else
      flash[:error] = "Sorry, you have already complained"
      redirect_to :back
    end
  end

  def hide
    authenticate_admin!

    @post = Post.find(params[:id])
    @post.complained = false
    @post.save

    redirect_to :back, :notice => "Hided successfully"
  end

end
