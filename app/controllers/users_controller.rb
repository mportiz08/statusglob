require 'oauth'
require 'yml'

class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Registration successful."
      redirect_to root_url
    else
      render :action => "new"
    end
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully saved settings."
      redirect_to root_url
    else
      render :action => "edit"
    end
  end

  def show
    @user = User.find(params[:id])
  end

def connect
  @request_token = consumer(params["account").get_request_token
  session[:request_token] = @request_token.token
  session[:request_token_secret] = @request_token.secret
  # send to site to authorize
  redirect_to @request_token.authorize_url
  return
end

def twitter_callback
  consumer = consumer("twitter")
  @request_token = OAuth::RequestToken.new(consumer, session[:request_token], session[:request_token_secret])
  # Exchange the request token for an access token.
  @access_token = @request_token.get_access_token
  @response = consumer.request(:get, "/account/verify_credentials.json", @access_token, { :scheme => :query_string })
  case @response
    when Net::HTTPSuccess
      user_info = JSON.parse(@response.body)
      unless user_info['screen_name']
        flash[:notice] = “Authentication failed”
        redirect_to :action => :index
        return
      end
      # We have an authorized user, save the information to the database.
      @account = TwitterAccount.new({ :token => @access_token.token, :secret => @access_token.secret })
      @account.save!
      # Redirect to the show page
      redirect_to(@user)
    else
      RAILS_DEFAULT_LOGGER.error “Failed to get user info via OAuth”
      # The user might have rejected this application. Or there was some other error during the request.
      flash[:notice] = “Authentication failed”
      redirect_to :action => :index
      return
    end
  end
end
  
  private
  
  def settings(account)
    settings = YAML::load(File.open("#{Rails.root}/config/accounts.yml"))[account]
  end
  
  def consumer(account)
    settings = settings(account)
    OAuth::Consumer.new(settings["consumer_key"], settings["consumer_secret"], {:site=>settings["site"]})
  end
end
