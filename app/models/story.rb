class Story < ActiveRecord::Base
  validates_uniqueness_of :link_digg
  belongs_to :user
end
