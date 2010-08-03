require 'oauth'
require 'json'

class User < ActiveRecord::Base
  acts_as_authentic
  has_one :twitter_account
  has_many :tweets
  
  def update_tweets
    return if twitter_account.nil?
    
    request = "/statuses/home_timeline.json"
    access_token = OAuth::AccessToken.new(consumer("twitter"), twitter_account.token, twitter_account.secret)
    
    if tweets.nil?
      JSON.parse(access_token.get(request).body).each do |tweet|
        Tweet.new(:username => tweet["user"]["screen_name"], :content => tweet["text"], :date_posted => DateTime.parse(tweet["created_at"])).save!
      end
    else
      if 
    end
  end
end
