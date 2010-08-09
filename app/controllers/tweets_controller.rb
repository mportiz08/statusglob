class TweetsController < ApplicationController
  before_filter :require_user
  
  def index
    unless current_user.twitter?
      flash[:notice] = "your twitter account hasn't been connected"
      redirect_to root_url
    end
    
    flash[:error] = "twitter might be down" unless current_user.update_tweets
    @tweets = current_user.tweets.all(:order => "date_posted DESC", :limit => 20)
  end
end
