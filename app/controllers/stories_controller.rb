class StoriesController < ApplicationController
  before_filter :require_user
  
  def index
    unless current_user.digg?
      flash[:notice] = "your digg account hasn't been connected"
      redirect_to root_url
    end
    
    flash[:error] = "digg might be down" unless current_user.update_stories
    @stories = current_user.stories.all(:order => "date_posted DESC", :limit => 20)
  end
end
