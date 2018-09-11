class Api::V2::Splus::PasswordResetsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by(:email => params[:password_reset][:email].downcase)
    if @user
      req = Splus.new.reset @user.email
      check req
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_path
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

end
