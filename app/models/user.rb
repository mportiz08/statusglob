class User < ActiveRecord::Base
  acts_as_authentic
  has_one :twitter_account
  has_many :tweets
end
