class MainController < ApplicationController
  def index
    unless current_user.nil? || current_user.twitter_account.nil? || current_user.facebook_account.nil? || current_user.digg_account.nil?
      flash[:error] = "twitter might be down" unless current_user.update_tweets
      flash[:error] = "facebook might be down" unless current_user.update_statuses
      flash[:error] = "digg might be down" unless current_user.update_stories
      @tweets = current_user.tweets.all(:order => "date_posted DESC", :limit => 20)
      @statuses = current_user.statuses.all(:order => "date_posted DESC", :limit => 20)
      @stories = current_user.stories.all(:order => "date_posted DESC", :limit => 20)
      @messages = @tweets + @statuses + @stories
      @messages = @messages.sort_by { |m| m.date_posted }
      @messages.reverse!
    end
  end
end
