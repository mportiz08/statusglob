class Tweet < ActiveRecord::Base
  validates_presence_of :username, :content, :date_posted
  belongs_to :user
end
