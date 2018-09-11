class HomeController < ApplicationController
  before_action :authenticate

  def authenticate
    if logged_in?
      redirect_to api_v2_splus_user_path(@current_user.id)
    else
      redirect_to api_v2_splus_login_path
    end
  end

  def show
  end
end
