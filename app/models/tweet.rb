class Tweet < ActiveRecord::Base
  validates_presence_of :username, :content, :date_posted, :site_id
  validates_uniqueness_of :content
  belongs_to :user
end
