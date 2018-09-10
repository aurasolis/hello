class Api::V2::Splus::UsersController < ApplicationController
  include SessionsHelper
  include UsersHelper

  def new
    @user = User.new
  end

  def show
    user = User.find(params[:id])
    #se repite la búsqueda cuando viene de login y registro :/
    req = Splus.new.obtain user.sp_card
    res = final_response(req)
    @current_user = user
  end

  def create
    #está bien que primero lo cree y guarde, luego haga la llamada y loa actualice?
    !!params[:provider] ? user = User.find_or_create_from_auth_hash(request.env["omniauth.auth"]) : user = User.find_or_create_from_params(user_params)
    if user
      req = Splus.new.register user
      res = final_response(req)
      user.update_attributes(res)
      remember user
      flash[:info] = "Signed in!"
      redirect_to user
    else
      redirect_to request.referer
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
                                 :email,:email_confirmation,:birthday,:sp_card,:picture,:uid)
  end

end
