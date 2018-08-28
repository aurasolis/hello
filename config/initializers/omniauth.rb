Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, "799725790418754", "4c1719f348f8a768c070a7ac62e0cf33",
  scope: 'profile'
  provider :google_oauth2, "261090695743-c89vudltb35np6ptnckboq24e7dmsc4u.apps.googleusercontent.com", "PQD9sr-v0VtDlp_UmJxcb6Zs",
  scope: ['email','profile'], image_aspect_ratio: 'square', image_size: 48, access_type: 'online'
end
