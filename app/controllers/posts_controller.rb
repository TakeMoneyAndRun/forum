class PostsController < ApplicationController

  load_and_authorize_resource :forum
  load_and_authorize_resource :topic, :through => :forum
  load_and_authorize_resource :post, :through => :topic, :except => [:vote, :complain]

  before_filter :authenticate_user!

  def new

  end

  def create
    if Topic.exists?(params[:topic_id])

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



    @topic = @post.topic
    @forum =  @topic.forum

  end

  def update

    if @post.update_attributes(params[:post])
      redirect_to forum_topic_path(params[:forum_id], params[:topic_id])
    else
      render 'edit'
    end
  end

  def destroy

      @post.body = 'Deleted'
      @post.save

      redirect_to forum_topic_path(params[:forum_id], params[:topic_id])

  end

  def vote
    authenticate_user!
   @post = Post.find(params[:id])

    if @post.votes.where(user_id: current_user.id).exists?
      flash[:error] = "Sorry, you have already voted"
      redirect_to :back
    else
      @post.increment(:rating)
      @post.save

      @vote = Vote.new(params[:vote])
      @vote.user = current_user
      @vote.post = @post
      @vote.save

      redirect_to :back, :notice => "Voted successfully"
    end
  end

  def complain
    authenticate_user!
    @post = Post.find(params[:id])

    if @post.complains.where(user_id: current_user.id).exists?
      flash[:error] = "Sorry, you have already complained"
      redirect_to :back
    else
      @post.complained = true

      @complain = Complain.new(params[:complain])
      @complain.user = current_user
      @complain.post = @post

      if @post.save && @complain.save
        redirect_to :back, :notice => "Complained successfully"
      else
        flash[:error] = "Smth went wrong"
        redirect_to :back
      end
    end
  end

  def hide
    if current_user.has_role? :admin
      @post = Post.find(params[:id])
      @post.complained = false

      if @post.save
        redirect_to :back, :notice => "Hided successfully"
      else
        flash[:error] = "Smth went wrong"
        redirect_to :back
      end
    else
      flash[:error] = "You dont have permission"
      redirect_to :back
    end
  end
end
