module DeliciousHelper
  def display_bookmark(bookmark)
    @html = "<div class=\"message-left\">#{bookmark_display_avatar(bookmark)}</div>
             <div class=\"message-right\">
               <div class=\"author\">#{link_to(image_tag("icon_delicious_small.png"), "http://delicious.com", { :target => "_blank" })}&nbsp;&nbsp;#{bookmark_get_profile_link(bookmark)}&nbsp;#{bookmark_get_timestamp(bookmark)}</div>
               <div class=\"message\">
                 <h4>#{link_to(bookmark.title, bookmark.link, { :target => "_blank" })}</h4>
                 #{bookmark.description}#{bookmark_get_break(bookmark)}
                 <span class=\"tags\">tagged: #{bookmark.tags}</span>
               </div>
             </div>
             <div class=\"clear\">"
    auto_link(@html, :all, :target => '_blank')
  end
  
  private
  
  def bookmark_display_avatar(bookmark)
    link_to(image_tag("delicious_avatar.png", { :width => 48, :height => 48}), "http://digg.com/users/#{bookmark.username}", { :target => "_blank" })
  end
  
  def bookmark_get_profile_link(bookmark)
    link_to(bookmark.username, "http://delicious.com/#{bookmark.username}", { :target => "_blank" })
  end
  
  def bookmark_get_timestamp(bookmark)
    link_to("saved #{time_ago_in_words(bookmark.date_posted)} ago", bookmark.link, { :class => "timestamp", :target => "_blank" })
  end
  
  def bookmark_get_break(bookmark)
    "<br />" unless bookmark.description.empty?
  end
end
