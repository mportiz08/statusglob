require 'json'
require 'oauth'

class MainController < ApplicationController
  def index
    unless current_user.nil? || current_user.twitter_account.nil?
      request = "/statuses/home_timeline.json"
      access = current_user.twitter_account
      access_token = OAuth::AccessToken.new(consumer("twitter"), access.token, access.secret)
      @response = JSON.parse(access_token.get(request).body)
    end
  end
end
