class TopicsController < ApplicationController

  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :load_forum, :except => :move


  def index
    @topics=@forum.topics
    add_breadcrumb @forum.name, forum_topics_path(@forum)
  end

  def new
    @topic = @forum.topics.build
    @post = @topic.posts.build
  end

  def create
    @topic = @forum.topics.build(params[:topic])
    @post = @topic.posts.build(params[:post])
    @post.note = false
    @topic.user = @post.user = current_user

    if @topic.save
      redirect_to :action => :index
    else
      render 'new'
    end
  end

  def show
    @topic = @forum.topics.find(params[:id])
    @forums = Forum.all

    if params[:search].present?
      @posts = @topic.posts.published.where("body LIKE '%#{params[:search]}%'") .paginate(:page => params[:page])
    else
      @posts = @topic.posts.published.paginate(:page => params[:page])
    end

    add_breadcrumb @forum.name, forum_topics_path(@forum)
    add_breadcrumb @topic.name, forum_topic_path(@forum,@topic)
  end

  def edit
    @topic = @forum.topics.find(params[:id])
    @post = @topic.posts.first

    unless logged?(@topic.user_id) || admin?
      flash[:error] = 'You dont have access to this page'
      redirect_to root_url
    end

  end

  def update
    @topic = @forum.topics.find(params[:id])

    unless logged?(@topic.user_id) || admin?
      flash[:error] = 'You dont have access to this page'
      redirect_to root_url
    end

    if @topic.update_attributes(params[:topic])
      redirect_to :action => :index
    else
      render 'edit'
    end
  end

  def close
    @topic = @forum.topics.find(params[:id])
    @topic.closed = true

    if @topic.save
      redirect_to :back, :notice => "Topic is closed"
    else
      flash[:error] = 'Smth went wrong'
      redirect_to :back
    end
  end

  def open
    @topic = @forum.topics.find(params[:id])
    @topic.closed = false

    if @topic.save
      redirect_to :back, :notice => "Topic is opened"
    else
      flash[:error] = 'Smth went wrong'
      redirect_to :back
    end
  end

  def destroy
    @topic = @forum.topics.find(params[:id])

    if logged?(@topic.user_id) || moderator? || admin?
      @topic.destroy
      redirect_to :action => :index
    else
      flash[:error] = 'You dont have access to this action'
      redirect_to :back
    end
  end

  def move
    authenticate_admin!
    @topic = Topic.find(params[:id])
    @topic.update_attributes(params[:topic])

    redirect_to root_url, :notice => "Topic is moved"
  end


  protected


  def load_forum
    @forum = Forum.find(params[:forum_id])
  end

end
