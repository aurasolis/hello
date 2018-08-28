class SessionsController < ApplicationController

  def create
      @user = User.find_or_create_from_auth_hash(request.env["omniauth.auth"])
  	   session[:user_id] = @user.id
  	   redirect_to :me
  end

  def destroy
    if current_user
        session.delete(:user_id)
        flash[:success] = 'See you!'
      end
      redirect_to root_path
    end

end
