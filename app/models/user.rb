require 'oauth'
require 'json'
require 'open-uri'
require 'lib/accounts'
require 'ap'

REFRESH_INTERVAL = 300 # 5 minutes in seconds

class User < ActiveRecord::Base
  acts_as_authentic
  has_one :twitter_account
  has_one :facebook_account
  has_many :tweets
  has_many :statuses
  
  def twitter?
    !twitter_account.nil?
  end
  
  def facebook?
    !facebook_account.nil?
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
    tweets.create(:username => tweet["user"]["screen_name"],
                  :content => tweet["text"],
                  :date_posted => DateTime.parse(tweet["created_at"]),
                  :site_id => tweet["id"],
                  :avatar => tweet["user"]["profile_image_url"])
  end
  
  def update_statuses
    return if facebook_account.nil?
    
    if statuses.empty?
      feed = get_fb_feed
      feed.each do |item|
        if item["type"] == "status"
          add_status(item)
        end
      end
    else
      # wait at least 5 minutes before bothering facebook again
      if (Time.now - statuses.last.created_at) >= REFRESH_INTERVAL
        feed = get_fb_feed
        feed.each do |item|
          if item["type"] == "status"
            add_status(item)
          end
        end
      end
    end
  end
  
  def add_status(status)
    statuses.create(:name => status["from"]["name"],
                    :name_id => status["from"]["id"],
                    :message => status["message"],
                    :date_posted => DateTime.parse(status["created_time"]),
                    :site_id => status["id"],
                    :link => status["actions"].first["link"],
                    :avatar => "http://graph.facebook.com/#{status["from"]["id"]}/picture")
  end
  
  private
  
  def get_fb_feed
    url = URI.parse("https://graph.facebook.com/me/home?access_token=#{CGI::escape(facebook_account.token)}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = (url.scheme == "https")
    tmp_url = "#{url.path}?#{url.query}"
    request = Net::HTTP::Get.new(tmp_url)
    ap http.request(request).body
    response = JSON.parse(http.request(request).body)["data"]
  end
end
