class PasswordResetsController < ApplicationController
  #skip_before_action :authenticate, only: [:new, :create]
  include UsersHelper

  def new
  end

  def create
    @user = User.where(:email => params[:password_reset][:email].downcase,
                        :birthday => params[:password_reset][:birthday])
    if @user
      debugger
      req = retrieve_req(@user.birthday, @user.email)
      res = req.parsed_response
      parsing_user_info @user,res
      flash[:info] = "Email sent with password reset instructions"
      debugger
      redirect_to root_path
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

end
