class SessionsController < ApplicationController
  include UsersHelper
  include SessionsHelper

  def new
  end

  def create
    #@user = User.find_or_create_from_auth_hash(request.env["omniauth.auth"])
    #log_in @user
    #remember token
    #redirect_to :me, notice: "Signed in!"
    user = User.find_by(sp_card: params[:session][:sp_card])
    debugger
    if user
      req = obtain_req(user)
      res = req.parsed_response
      parsing_user_info user,res
      debugger
      log_in user
      remember user
      redirect_to user
    else
      flash.now[:danger] = 'Invalid card and nip combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

end
