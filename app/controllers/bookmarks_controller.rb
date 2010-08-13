class BookmarksController < ApplicationController
  before_filter :require_user
  
  def index
    unless current_user.delicious?
      flash[:notice] = "your delicious account hasn't been connected"
      redirect_to root_url
    end
    
    flash[:error] = "delicious might be down" unless current_user.update_bookmarks
    @bookmarks = current_user.bookmarks.all(:order => "date_posted DESC", :limit => 20)
  end
end
