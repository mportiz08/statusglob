# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include TwitterHelper
  include FacebookHelper
  
  def app_name
    "status *"
  end
end
