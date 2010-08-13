class MainController < ApplicationController
  def index
    unless current_user.nil? || current_user.twitter_account.nil? || current_user.facebook_account.nil? || current_user.digg_account.nil?
      flash[:error] = "twitter might be down" unless current_user.update_tweets
      flash[:error] = "facebook might be down" unless current_user.update_statuses
      flash[:error] = "digg might be down" unless current_user.update_stories
      flash[:error] = "delicious might be down" unless current_user.update_bookmarks
      
      @tweets = current_user.tweets.all(:order => "date_posted DESC", :limit => 10)
      @statuses = current_user.statuses.all(:order => "date_posted DESC", :limit => 10)
      @stories = current_user.stories.all(:order => "date_posted DESC", :limit => 10)
      #@bookmarks = current_user.bookmarks.all(:order => "date_posted DESC", :limit => 10)
      
      @messages = @tweets + @statuses + @stories
      @messages = @messages.sort_by { |m| m.date_posted }
      @messages.reverse!
    end
  end
end
