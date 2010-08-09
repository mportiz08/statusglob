class StatusesController < ApplicationController
  before_filter :require_user
  
  def index
    unless current_user.facebook?
      flash[:notice] = "your facebook account hasn't been connected"
      redirect_to root_url
    end
    
    flash[:error] = "facebook might be down" unless current_user.update_statuses
    @statuses = current_user.statuses.all(:order => "date_posted DESC", :limit => 20)
  end
end
