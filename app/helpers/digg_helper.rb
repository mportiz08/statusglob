module DiggHelper
  def display_story(story)
    @html = "<div class=\"message-left\">#{story_display_avatar(story)}</div>
             <div class=\"message-right\">
               <div class=\"author\">#{link_to(image_tag("icon_digg_small.png"), "http://digg.com", { :target => "_blank" })}&nbsp;&nbsp;#{story_get_profile_link(story)}&nbsp;#{story_get_timestamp(story)}</div>
               <div class=\"message\"><h4>#{link_to(story.title, story.link_external, { :target => "_blank" })}</h4>#{story.description}</div>
             </div>
             <div class=\"clear\">"
    auto_link(@html, :all, :target => '_blank')
  end
  
  private
  
  def story_display_avatar(story)
    if story.avatar.nil?
      link_to(image_tag("temp/default.jpg", { :width => 48, :height => 48}), "http://digg.com/users/#{story.username}", { :target => "_blank" })
    else
      link_to(image_tag(story.avatar, { :width => 48, :height => 48}), "http://digg.com/users/#{story.username}", { :target => "_blank" })
    end
  end
  
  def story_get_profile_link(story)
    link_to(story.username, "http://digg.com/users/#{story.username}", { :target => "_blank" })
  end
  
  def story_get_timestamp(story)
    link_to("dugg #{time_ago_in_words(story.date_posted)} ago", story.link_digg, { :class => "timestamp", :target => "_blank" })
  end
end
