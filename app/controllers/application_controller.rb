class ApplicationController < ActionController::Base


  helper_method :counter


  def counter
    t = 255.minutes.ago
    @counter = ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM sessions WHERE(updated_at > '#{t.to_s(:sql)}')")[0][0]
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
      #url = eval(url) if url =~ /_path|_url|@/
      @breadcrumbs << [name, url]
    end

    def self.add_breadcrumb name, url, options = {}
      before_filter options do |controller|
        controller.send(:add_breadcrumb, name, url)
      end
    end

  add_breadcrumb 'Forums', '/'


  private



end
