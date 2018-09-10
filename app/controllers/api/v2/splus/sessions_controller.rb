class Api::V2::Splus::SessionsController < ApplicationController
  include UsersHelper
  include SessionsHelper

  def new
  end

  def create
    #hacer llamada primero, si esta actualizarlo, si no crearlo.
    req = Splus.new.login login_params[:sp_card], login_params[:nip]
    res = final_response(req)
    user = User.find_by(:sp_card => res[:sp_card])
      if user
        user.update_attributes(res)
        user[:nip] = login_params[:nip]
      else #porque puede no haberse registrado en nuestra pag pero sí estar en la de sp??
        user = User.create(res)
        user[:nip] = login_params[:nip]
      end
      remember user
      flash[:info] = "Signed in!"
      redirect_to user
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private

  def login_params
    params.require(:session).permit(:sp_card,:nip)
  end

end
