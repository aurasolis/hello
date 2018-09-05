class SessionsController < ApplicationController
  #skip_before_action :authenticate, only: [:new, :create]
  include UsersHelper
  include SessionsHelper

  def new
  end

  def create
    user = User.where(:sp_card => params[:session][:sp_card],
                      :nip => params[:session][:nip])
    debugger
    if user
      req = login_req(user.sp_card, user.nip)
      res = req.parsed_response
      parsing_user_info user,res
      debugger
      log_in user
      remember user
      flash[:info] = "Signed in!"
      redirect_to user
    else
      flash.now[:danger] = 'Invalid card and nip combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to 'home#show'
  end

end
