class MainController < ApplicationController
  def index
    unless current_user.nil? || current_user.twitter_account.nil?
      flash[:error] = "twitter might be down" unless current_user.update_tweets
      @tweets = current_user.tweets.all(:order => "date_posted DESC", :limit => 20)
    end
  end
end
