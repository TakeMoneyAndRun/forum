class ApplicationController < ActionController::Base


  helper_method :current_user, :admin?, :moderator?, :logged?, :counter

  before_filter :check_banned


  def admin?
    current_user && current_user.permission_level == 2
  end

  def moderator?
    current_user && current_user.permission_level == 1
  end

  def logged?(id)
    current_user && current_user.id == id
  end


  def counter
    t = 255.minutes.ago
    @counter = Integer(ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM sessions WHERE(updated_at > '#{t.to_s(:sql)}')").to_s.at(14))
  end


  protected

    def check_banned
      if current_user && current_user.ban.present?
        flash[:error] = 'Sorry, you are banned'
        session[:user_id] = nil
      end
    end


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

  def authenticate_user!
    unless current_user
      flash[:error] = 'Log in to get to this page'
      redirect_to log_in_path
    end
  end

  def authenticate_admin!
    unless admin?
      flash[:error] = 'You dont have access to this page'
      redirect_to root_url
    end
  end

end
