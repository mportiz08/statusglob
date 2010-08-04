class Tweet < ActiveRecord::Base
  validates_presence_of :username, :content, :date_posted, :site_id, :avatar
  validates_uniqueness_of :site_id
  belongs_to :user
end
