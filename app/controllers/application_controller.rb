class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user
  include SessionsHelper

  def authenticate
    if user_signed_in?
      redirect_to current_user
    else
      redirect_to root_path
    end
  end

  # Returns the user corresponding to the remember token cookie.
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && User.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  #def current_user
  	#@current_user ||= User.find(session[:user_id]) if session[:user_id]
  #end

  def user_signed_in?
  	!!current_user
  end

end
