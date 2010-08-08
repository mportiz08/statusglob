class FacebookAccount < ActiveRecord::Base
  validates_presence_of :user_id, :token, :secret
  belongs_to :user
end
