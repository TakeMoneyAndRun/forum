class TopicsController < ApplicationController
  before_filter :load_forum, :except => :move

  def index
   @topics=@forum.topics
   add_breadcrumb @forum.name, 'forum_topics_path(@forum)'
 end

  def new
    is_user?
    @topic = Topic.new
    @post = @topic.posts.build
  end

  def create
    is_user?
    @topic = Topic.new(params[:topic])
    @post = @topic.posts.build(params[:post])
    @topic.user = @post.user = current_user
    @topic.forum =  @forum
    if @topic.save
      redirect_to :action => :index
    else
      render 'new'
    end
  end

  def show
    @topic = Topic.find(params[:id])
    @forums = Forum.all
    if params[:search].present?
      @posts = @topic.posts.where("body LIKE '%#{params[:search]}%'").paginate(:page => params[:page])
    else
      @posts = @topic.posts.paginate(:page => params[:page])
    end
    add_breadcrumb @forum.name, 'forum_topics_path(@forum)'
    add_breadcrumb @topic.name, 'forum_topic_path(@forum,@topic)'
  end

  def edit
    is_user?
    @topic = Topic.find(params[:id])
    @post = Post.find_by_id(1)
    unless owner?(@topic.user.id)
      redirect_to root_url
      flash[:error] = 'You dont have access to this page'
    end

  end

  def update
    is_user?
    @topic = Topic.find(params[:id])
    unless owner?(@topic.user.id)
      redirect_to root_url
      flash[:error] = 'You dont have access to this page'
    end
    if @topic.update_attributes(params[:topic])
      redirect_to :action => :index
    else
      render 'edit'
    end
  end

  def close
    @topic = Topic.find(params[:id])
    @topic.closed = true
    @topic.save
    redirect_to :back, :notice => "Topic is closed"
  end

  def open
    @topic = Topic.find(params[:id])
    @topic.closed = false
    @topic.save
    redirect_to :back, :notice => "Topic is opened"
  end



  def destroy
    is_admin?
    @topic = Topic.find(params[:id])
    @topic.destroy

    redirect_to :action => :index
  end

  def move
    is_admin?
    @topic = Topic.find(params[:id])
    @topic.update_attributes(params[:topic])
    redirect_to root_url, :notice => "Topic is moved"
  end

  protected

  def load_forum
    if Forum.exists?(params[:forum_id])
    @forum = Forum.find(params[:forum_id])
    else
      redirect_to(forums_path, :notice =>"Please specify a valid forum")
    end
  end


end
