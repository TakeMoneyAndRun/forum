class ApplicationController < ActionController::Base



  helper_method :current_user, :admin?, :moderator?, :owner?

  def admin?
     current_user && current_user.permission_level == 2
  end

  def moderator?
    current_user && current_user.permission_level == 1
  end

  def owner?(id)
    current_user && current_user.id == id
  end

  def counter
 @counter = ActiveRecord::Base.connection.execute("COUNT * FROM sessions")
  end

  protected

  def add_breadcrumb name, url = ''
    @breadcrumbs ||= []
    url = eval(url) if url =~ /_path|_url|@/
    @breadcrumbs << [name, url]
  end

  def self.add_breadcrumb name, url, options = {}
    before_filter options do |controller|
      controller.send(:add_breadcrumb, name, url)
    end
  end

  add_breadcrumb 'Forums', '/'



  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def is_user?
    unless current_user
      redirect_to log_in_path
      flash[:error] = 'Log in to get to this page'
    end
  end

  def is_admin?
    unless admin?
      redirect_to root_url
      flash[:error] = 'You dont have access to this page'
    end
  end






end
