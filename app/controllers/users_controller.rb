class UsersController < ApplicationController
  include SessionsHelper
  include UsersHelper

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    params[:provider] ? @user = User.find_or_create_from_auth_hash(request.env["omniauth.auth"]) : @user = User.new(user_params)
    if @user.save
      debugger
      req = validate_req(@user)
      res = req.parsed_response
      parsing_user_info @user,res
      log_in @user
      remember @user
      debugger
      flash[:info] = "Signed in!"
      redirect_to @user
    else
      render 'new'
    end
  end

  #def edit
    #@user = User.find(params[:id])
  #end

  #def update
    #@user = User.find(params[:id])
    #if @user.update_attributes(user_params)
    #redirect_to @user
    #else
      #render 'edit'
    ##end
  #end

  private

  def user_params
    params.require(:user).permit(:first_name,:last_name,:provider,
                                 :email,:birthday,:sp_card,:picture,:uid)
  end

end
