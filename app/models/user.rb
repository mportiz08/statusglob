require 'oauth'
require 'json'
require 'open-uri'
require 'digest/md5'
require 'lib/accounts'

REFRESH_INTERVAL = 300 # 5 minutes in seconds

class User < ActiveRecord::Base
  acts_as_authentic
  
  has_one :twitter_account
  has_one :facebook_account
  has_one :digg_account
  has_one :delicious_account
  
  has_many :tweets
  has_many :statuses
  has_many :stories
  has_many :bookmarks
  
  def twitter?
    !twitter_account.nil?
  end
  
  def facebook?
    !facebook_account.nil?
  end
  
  def digg?
    !digg_account.nil?
  end
  
  def delicious?
    !delicious_account.nil?
  end
  
  def gravatar
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.downcase)}?s=200&d=mm"
  end
  
  def registered
    created_at.strftime("%B %d, %Y")
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
  
  def update_stories
    return if digg_account.nil?
    
    if stories.empty?
      get_digg_feed
    else
      if(Time.now - stories.last.created_at) >= REFRESH_INTERVAL
        get_digg_feed
      end
    end
  end
  
  def update_bookmarks
    return if delicious_account.nil?
    
    if bookmarks.empty?
      get_delicious_feed
    else
      if(Time.now - bookmarks.last.created_at) >= REFRESH_INTERVAL
        get_delicious_feed
      end
    end
  end
  
  def add_tweet(tweet)
    tweets.create(:username    => tweet["user"]["screen_name"],
                  :content     => tweet["text"],
                  :date_posted => DateTime.parse(tweet["created_at"]),
                  :site_id     => tweet["id"],
                  :avatar      => tweet["user"]["profile_image_url"])
  end
  
  def add_status(status)
    statuses.create(:name        => status["from"]["name"],
                    :name_id     => status["from"]["id"],
                    :message     => status["message"],
                    :date_posted => DateTime.parse(status["created_time"]),
                    :site_id     => status["id"],
                    :link        => status["actions"].first["link"],
                    :avatar      => "http://graph.facebook.com/#{status["from"]["id"]}/picture")
  end
  
  def add_story(story)
    stories.create(:username      => story["friends"]["users"].first["name"],
                   :avatar        => story["friends"]["users"].first["icon"],
                   :title         => story["title"],
                   :description   => story["description"],
                   :link_digg     => story["href"],
                   :link_external => story["link"],
                   :date_posted   => Time.at(story["submit_date"]))
  end
  
  def add_bookmark(bookmark)
    bookmarks.create(:username    => bookmark["a"],
                     :description => bookmark["n"],
                     :title       => bookmark["d"],
                     :tags        => bookmark["t"].join(", "),
                     :link        => bookmark["u"],
                     :date_posted => DateTime.parse(bookmark["dt"]))
  end
  
  private
  
  def get_fb_feed
    url = URI.parse("https://graph.facebook.com/me/home?access_token=#{CGI::escape(facebook_account.token)}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = (url.scheme == "https")
    tmp_url = "#{url.path}?#{url.query}"
    request = Net::HTTP::Get.new(tmp_url)
    response = JSON.parse(http.request(request).body)["data"] || []
  end
  
  def get_digg_feed
    url = "http://services.digg.com/1.0/endpoint?method=friend.getDugg&type=json&username=#{digg_account.username}"
    begin
      request = open(url, "User-Agent" => "statusglob").read
      response = JSON.parse(request)
      response["stories"].each do |story|
        add_story(story)
      end
    rescue OpenURI::HTTPError
      logger.debug "digg might be down"
    end
  end
  
  def get_delicious_feed
    url = "http://feeds.delicious.com/v2/json/network/#{delicious_account.username}?count=20"
    begin
      request = open(url, "User-Agent" => "statusglob").read
      response = JSON.parse(request)
      response.each do |bookmark|
        add_bookmark(bookmark)
      end
    rescue OpenURI::HTTPError
      logger.debug "delicious might be down"
    end
  end
end
