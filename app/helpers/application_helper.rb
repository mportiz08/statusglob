# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def display_tweet(tweet)
    @html = "<div class=\"author\">#{tweet.username} <span class=\"timestamp\">said #{time_ago_in_words(tweet.date_posted)} ago</span></div>
             <div class=\"message\">#{tweet.content}</div>"
    auto_link(@html, :all, :target => '_blank')
  end
end
