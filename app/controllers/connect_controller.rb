require 'lib/accounts'

class ConnectController < ApplicationController
  before_filter :require_user
  
  def index
  
  end
  
  def twitter
    (params[:id].eql?("callback")) ? twitter_callback() : twitter_request()
  end
  
  def facebook
    (params[:id].eql?("callback")) ? facebook_callback() : facebook_request()
  end
  
  private
  
  def facebook_request
    settings = Accounts.settings("facebook")
    redirect_to "#{settings["site"]}/oauth/authorize?client_id=#{settings["app_id"]}&redirect_uri=#{root_url}connect/facebook/callback&scope=read_stream,offline_access"
  end
  
  def facebook_callback
    if params[:code].nil?
      flash[:error] = "error"
      redirect_to :action => "index"
      return
    end
    
    settings = Accounts.settings("facebook")
    url = URI.parse("#{settings["site"]}/oauth/access_token?client_id=#{settings["app_id"]}&redirect_uri=#{root_url}connect/facebook/callback&client_secret=#{settings["app_secret"]}&code=#{CGI::escape(params[:code])}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = (url.scheme == "https")
    tmp_url = "#{url.path}?#{url.query}"
    request = Net::HTTP::Get.new(tmp_url)
    response = http.request(request)
    
    access_token = response.body.split("=")[1].split("&")[0]
    @account = FacebookAccount.new({ :user_id => current_user.id, :token => access_token, :secret => "" })
    @account.save!
    flash[:notice] = "Successfully connected your facebook account."
    redirect_to root_url
  end
  
  def twitter_request
    @request_token = Accounts.consumer("twitter").get_request_token(:oauth_callback => "#{root_url}connect/twitter/callback")
    session[:request_token] = @request_token.token
    session[:request_token_secret] = @request_token.secret
    # send to site to authorize
    redirect_to @request_token.authorize_url
    return
  end
  
  def twitter_callback
    consumer = Accounts.consumer("twitter")
    @request_token = OAuth::RequestToken.new(consumer, session[:request_token], session[:request_token_secret])
    # Exchange the request token for an access token.
    @access_token = @request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
    @response = consumer.request(:get, "/account/verify_credentials.json", @access_token, { :scheme => :query_string })
    case @response
    when Net::HTTPSuccess
      user_info = JSON.parse(@response.body)
      unless user_info['screen_name']
        flash[:notice] = "Authentication failed"
        redirect_to :action => :index
        return
      end
      # We have an authorized user, save the information to the database.
      @account = TwitterAccount.new({ :user_id => current_user.id, :token => @access_token.token, :secret => @access_token.secret })
      @account.save!
      # Redirect to the show page
      flash[:notice] = "Succesfully connected your twitter account."
      redirect_to(root_url)
    else
      RAILS_DEFAULT_LOGGER.error "Failed to get user info via OAuth"
      # The user might have rejected this application. Or there was some other error during the request.
      flash[:notice] = "Authentication failed"
      redirect_to :action => :index
      return
    end
  end
end
