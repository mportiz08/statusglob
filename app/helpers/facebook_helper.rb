module FacebookHelper
  def display_status(status)
    @html = "<div class=\"message-left\">#{facebook_display_avatar(status)}</div>
             <div class=\"message-right\">
               <div class=\"author\">#{link_to(image_tag("icon_facebook_small.png"), "http://facebook.com", { :target => "_blank" })}&nbsp;&nbsp;#{facebook_get_profile_link(status)}&nbsp;#{facebook_get_timestamp(status)}</div>
               <div class=\"message\">#{status.message}</div>
             </div>
             <div class=\"clear\">"
    auto_link(@html, :all, :target => '_blank')
  end
  
  private
  
  def facebook_display_avatar(status)
    if status.avatar.nil?
      link_to(image_tag("temp/default.jpg", { :width => 48, :height => 48}), "http://facebook.com/#{status.name_id}", { :target => "_blank" })
    else
      link_to(image_tag(status.avatar, { :width => 48, :height => 48}), "http://facebook.com/#{status.name_id}", { :target => "_blank" })
    end
  end
  
  def facebook_get_profile_link(status)
    link_to(status.name, "http://facebook.com/#{status.name_id}", { :target => "_blank" })
  end
  
  def facebook_get_timestamp(status)
    link_to("said #{time_ago_in_words(status.date_posted)} ago", status.link, { :class => "timestamp", :target => "_blank" })
  end
end
