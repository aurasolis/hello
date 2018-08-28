class HomeController < ApplicationController
  include AuthHelper

  def show
    @login_url = get_login_url
  end
end
