module TwitterHelper
  def display_tweet(tweet)
    @html = "<div class=\"message-left\">#{display_avatar(tweet)}</div>
             <div class=\"message-right\">
               <div class=\"author\">#{image_tag("icon_twitter.png")}&nbsp;&nbsp;#{get_profile_link(tweet)}&nbsp;#{get_timestamp(tweet)}</div>
               <div class=\"message\">#{tweet.content}</div>
             </div>
             <div class=\"clear\">"
    link_usernames(@html)
    auto_link(@html, :all, :target => '_blank')
  end
  
  private
  
  def display_avatar(tweet)
    if tweet.avatar.nil?
      link_to(image_tag("temp/default.jpg", { :width => 48, :height => 48}), "http://twitter.com/#{tweet.username}", { :target => "_blank" })
    else
      link_to(image_tag(tweet.avatar, { :width => 48, :height => 48}), "http://twitter.com/#{tweet.username}", { :target => "_blank" })
    end
  end
  
  def get_profile_link(tweet)
    link_to(tweet.username, "http://twitter.com/#{tweet.username}", { :target => "_blank" })
  end
  
  def get_timestamp(tweet)
    link_to("said #{time_ago_in_words(tweet.date_posted)} ago", "http://twitter.com/#{tweet.username}/status/#{tweet.site_id}", { :class => "timestamp", :target => "_blank" })
  end
  
  def link_usernames(html)
    html.gsub!(/@([a-z0-9_]+)/i, link_to("@\\1", "http://twitter.com/\\1", { :target => "_blank" }))
  end
end
