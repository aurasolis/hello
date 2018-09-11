class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user
  include SessionsHelper
  include SplusServices
  include SplusResponse

  # Returns the user corresponding to the remember token cookie.
  def current_user
    if cookies.signed[:user_id]
      user_id = cookies.signed[:user_id]
      user = User.find_by(id: user_id)
      token = find_token user.sp_card
      if user && token
        @current_user = user
      end
    end
  end

  def logged_in?
    !!current_user
  end
end
