class ProfilesController < ApplicationController

  before_filter :authenticate_user!

  def show
    @notes = current_user.posts.unpublished
    @complains = Post.complained
  end

end
