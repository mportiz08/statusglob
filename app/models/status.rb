class Status < ActiveRecord::Base
  validates_presence_of :name, :name_id, :message, :date_posted, :site_id, :link, :avatar
  validates_uniqueness_of :site_id
  belongs_to :user
end
