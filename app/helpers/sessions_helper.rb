module SessionsHelper

  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  def remember(user)
    User.generate_token(user)
    cookies.signed[:user_id] = { :value => user.id,
                :expires => 2.weeks.from_now,
                :httponly => true }
    cookies[:remember_token] = { :value => user.remember_token,
                :expires => 2.weeks.from_now,
                :httponly => true }
  end

  def logged_in?
    !current_user.nil?
  end


  def forget(user)
    debugger
    t = Token.find_by(:sp_card => user.sp_card)
    debugger
    t.update_attribute(:token, nil)
    debugger
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
end
