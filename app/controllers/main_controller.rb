class MainController < ApplicationController
  def index
    @messages = []
    @tweets = []
    @statuses = []
    @stories = []
    @bookmarks = []
    if current_user
      if current_user.twitter?
        current_user.update_tweets
        @tweets << current_user.tweets.all(:order => "date_posted DESC", :limit => 10)
      end
      
      if current_user.facebook?
        current_user.update_statuses
        @statuses << current_user.statuses.all(:order => "date_posted DESC", :limit => 10)
      end
      
      if current_user.digg?
        current_user.update_stories
        @stories << current_user.stories.all(:order => "date_posted DESC", :limit => 5)
      end
      
      if current_user.delicious?
        current_user.update_bookmarks
        @bookmarks << current_user.bookmarks.all(:order => "date_posted DESC", :limit => 5)
      end
      
      @messages << (@tweets + @statuses + @stories + @bookmarks)
      @messages = @messages.sort_by { |m| m.date_posted }
      @messages.reverse!
    end
  end
end
