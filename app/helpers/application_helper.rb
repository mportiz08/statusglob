# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include TwitterHelper
  
  def app_name
    "status *"
  end
end
