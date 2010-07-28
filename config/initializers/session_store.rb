# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_social_session',
  :secret      => 'e6636f0c029d1a4753a5f2614061c0afd23a8a10f35bb9027c3e16fb575fbb6d7c7b620c59976026e28baca631c075b933b15fcdc5a27e67310ab3cb3e55e747'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
