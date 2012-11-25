class TopicsController < ApplicationController
  load_and_authorize_resource :forum
  load_and_authorize_resource :topic, :through => :forum

  before_filter :authenticate_user!, :except => [:index, :show]


  def index
    add_breadcrumb @forum.name, forum_topics_path(@forum)
  end

  def new
    @post = @topic.posts.build
  end

  def create
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
    @post = @topic.posts.first

  end

  def update

    if @topic.update_attributes(params[:topic])
      redirect_to :action => :index
    else
      render 'edit'
    end
  end

  def close
    @topic.closed = true

    if @topic.save
      redirect_to :back, :notice => "Topic is closed"
    else
      flash[:error] = 'Smth went wrong'
      redirect_to :back
    end
  end

  def open
    @topic.closed = false

    if @topic.save
      redirect_to :back, :notice => "Topic is opened"
    else
      flash[:error] = 'Smth went wrong'
      redirect_to :back
    end
  end

  def destroy

      @topic.destroy
      redirect_to :action => :index

  end

  def move
    @topic = Topic.find(params[:id])
    @topic.update_attributes(params[:topic])

    redirect_to root_url, :notice => "Topic is moved"
  end


end
