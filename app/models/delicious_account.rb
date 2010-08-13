class DeliciousAccount < ActiveRecord::Base
  validates_presence_of :user_id, :username
  belongs_to :user
end
