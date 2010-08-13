module ConnectHelper
  def connect_twitter(user)
    "<li id=\"connection-twitter\">
      <div class=\"message-left\">#{twitter_icon(user)}</div>
      <div class=\"message-right\">
        <div class=\"author\">twitter <span class=\"timestamp\">#{twitter_added_text(user)}</span></div>
        <div class=\"message\">#{twitter_connected_text(user)}</div>
      </div>
      <div class=\"clear\"></div>
    </li>"
  end
  
  def connect_facebook(user)
    "<li id=\"connection-facebook\">
      <div class=\"message-left\">#{facebook_icon(user)}</div>
      <div class=\"message-right\">
        <div class=\"author\">facebook <span class=\"timestamp\">#{facebook_added_text(user)}</span></div>
        <div class=\"message\">#{facebook_connected_text(user)}</div>
      </div>
      <div class=\"clear\"></div>
    </li>"
  end
  
  def connect_digg(user)
    "<li id=\"connection-digg\">
      <div class=\"message-left\">#{digg_icon(user)}</div>
      <div class=\"message-right\">
        <div class=\"author\">digg <span class=\"timestamp\">#{digg_added_text(user)}</span></div>
        <div class=\"message\">#{digg_connected_text(user)}</div>
      </div>
      <div class=\"clear\"></div>
    </li>"
  end
  
  def connect_delicious(user)
    "<li id=\"connection-delicious\">
      <div class=\"message-left\">#{delicious_icon(user)}</div>
      <div class=\"message-right\">
        <div class=\"author\">delicious <span class=\"timestamp\">#{delicious_added_text(user)}</span></div>
        <div class=\"message\">#{delicious_connected_text(user)}</div>
      </div>
      <div class=\"clear\"></div>
    </li>"
  end
  
  private
  
  # twitter helpers
  def twitter_icon(user)
    (user.twitter?) ? image_tag("icon_twitter.png") : image_tag("icon-bw_twitter.png")
  end
  
  def twitter_added_text(user)
    (user.twitter?) ? "added #{time_ago_in_words(user.twitter_account.created_at)} ago" : "not added"
  end
  
  def twitter_connected_text(user)
    (user.twitter?) ? "<span class=\"connected\">connected</span>" : "#{link_to("click to connect", :action => "twitter")}"
  end
  
  # facebook helpers
  def facebook_icon(user)
    (user.facebook?) ? image_tag("icon_facebook.png") : image_tag("icon-bw_facebook.png")
  end
  
  def facebook_added_text(user)
    (user.facebook?) ? "added #{time_ago_in_words(user.facebook_account.created_at)} ago" : "not added"
  end
  
  def facebook_connected_text(user)
    (user.facebook?) ? "<span class=\"connected\">connected</span>" : "#{link_to("click to connect", :action => "facebook")}"
  end
  
  # digg helpers
  def digg_icon(user)
    (user.digg?) ? image_tag("icon_digg.png") : image_tag("icon-bw_digg.png")
  end
  
  def digg_added_text(user)
    (user.digg?) ? "added #{time_ago_in_words(user.digg_account.created_at)} ago" : "not added"
  end
  
  def digg_connected_text(user)
    (user.digg?) ? "<span class=\"connected\">connected</span>" : "#{link_to("click to connect", :action => "digg")}"
  end
  
  # delicious helpers
  def delicious_icon(user)
    (user.delicious?) ? image_tag("icon_delicious.png") : image_tag("icon-bw_delicious.png")
  end
  
  def delicious_added_text(user)
    (user.delicious?) ? "added #{time_ago_in_words(user.delicious_account.created_at)} ago" : "not added"
  end
  
  def delicious_connected_text(user)
    (user.delicious?) ? "<span class=\"connected\">connected</span>" : "#{link_to("click to connect", :action => "delicious")}"
  end
end
