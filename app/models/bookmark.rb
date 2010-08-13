class Bookmark < ActiveRecord::Base
  validates_uniqueness_of :link
  validates_presence_of :username, :title, :link
  belongs_to :user
end
