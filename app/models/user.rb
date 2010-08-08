require 'oauth'
require 'json'
require 'lib/accounts'

REFRESH_INTERVAL = 300 # 5 minutes in seconds

class User < ActiveRecord::Base
  acts_as_authentic
  has_one :twitter_account
  has_many :tweets
  has_many :statuses
  
  def twitter?
    !twitter_account.nil?
  end
  
  def update_tweets
    return if twitter_account.nil?
    
    request = "/statuses/home_timeline.json"
    access_token = OAuth::AccessToken.new(Accounts.consumer("twitter"), twitter_account.token, twitter_account.secret)
    
    if tweets.empty?
      begin
        JSON.parse(access_token.get(request).body).each do |tweet|
          add_tweet(tweet)
        end
      rescue JSON::ParserError
        logger.debug "something bad happened"
        return false
      end
    else
      # wait at least 5 minutes before bothering twitter again
      if (Time.now - tweets.last.created_at) >= REFRESH_INTERVAL
        # don't bother with tweets we've already seen
        request += "?since_id=#{tweets.last.site_id}"
        begin
          JSON.parse(access_token.get(request).body).each do |tweet|
            add_tweet(tweet)
          end
        rescue JSON::ParserError
          logger.debug "something bad happened"
          return false
        end
      end
    end
  end
  
  def add_tweet(tweet)
    tweets.create(:username => tweet["user"]["screen_name"], :content => tweet["text"],
                  :date_posted => DateTime.parse(tweet["created_at"]), :site_id => tweet["id"],
                  :avatar => tweet["user"]["profile_image_url"])
  end
end
