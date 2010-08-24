class Tweet < ActiveRecord::Base
  validates_presence_of :username, :content, :date_posted, :site_id, :avatar
  validates_uniqueness_of :site_id, :content
  belongs_to :user
end
