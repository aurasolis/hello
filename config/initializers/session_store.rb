Rails.application.config.session_store(
  :active_record_store,
  :key => '_foo_session', # any value
  :secure => Rails.env.production? || Rails.env.staging?, # Only send cookie over SSL when in production and staging
  :http_only => true # Don't allow Javascript to access the cookie (mitigates cookie-based XSS exploits)
)
