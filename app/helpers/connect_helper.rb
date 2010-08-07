module ConnectHelper
  def connect_twitter(user)
    "<li id=\"connection-twitter\">
      <div class=\"message-left\">#{icon(user)}</div>
      <div class=\"message-right\">
        <div class=\"author\">twitter <span class=\"timestamp\">#{added_text(user)}</span></div>
        <div class=\"message\">#{connected_text(user)}</div>
      </div>
      <div class=\"clear\"></div>
    </li>"
  end
  
  private
  
  def icon(user)
    (user.twitter?) ? image_tag("icon_twitter.png") : image_tag("icon-bw_twitter.png")
  end
  
  def added_text(user)
    (user.twitter?) ? "added #{time_ago_in_words(user.twitter_account.created_at)} ago" : "not added"
  end
  
  def connected_text(user)
    (user.twitter?) ? "<span class=\"connected\">connected</span>" : "#{link_to("click to connect", :action => "twitter")}"
  end
end
