class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.find_or_create_from_auth_hash(request.env["omniauth.auth"])
  	session[:user_id] = @user.id
  	redirect_to :me
  end

  def create_with_regular_data
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:card])
      log_in user
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    if current_user
      log_out
      flash[:success] = 'See you!'
    end
      redirect_to root_path
  end

end
