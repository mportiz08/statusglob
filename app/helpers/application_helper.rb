# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def display_tweet(tweet)
    @html = "<div class=\"message-left\">#{display_avatar(tweet)}</div>
             <div class=\"message-right\">
               <div class=\"author\">#{tweet.username} <span class=\"timestamp\">said #{time_ago_in_words(tweet.date_posted)} ago</span></div>
               <div class=\"message\">#{tweet.content}</div>
             </div>
             <div class=\"clear\">"
    auto_link(@html, :all, :target => '_blank')
  end
  
  def display_avatar(tweet)
    if tweet.avatar.nil?
      image_tag("temp/default.jpg")
    else
      image_tag(tweet.avatar)
    end
  end
end
