# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  helper_method :current_user
  
  def connect
    @request_token = consumer(params[:id]).get_request_token(:oauth_callback => "#{root_url}application/twitter_callback")
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
  
  private
  
  def settings(account)
    settings = YAML::load(File.open("#{Rails.root}/config/accounts.yml"))[account]
  end
  
  def consumer(account)
    settings = settings(account)
    OAuth::Consumer.new(settings["consumer_key"], settings["consumer_secret"], {:site=>settings["site"]})
  end
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    @current_user = current_user_session && current_user_session.record
  end
end
