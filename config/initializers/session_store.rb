# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_qonvoy_session',
  :secret      => '65f27f3090ef20e4961effa89772cddb54a74f65621ceb6a341a125595d8a50699ed7e103673581b561ac1b519e8d86052e715d5629ce1da2a09a5595a9e8eb3'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
