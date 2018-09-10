module SessionsHelper

  # Logs in the given user. Nunca guardamos el user_id en la sesión.
  #def log_in(user)
    #session[:user_id] = user.id
  #end

  def remember(user)
    Token.generate_token(user)
    cookies.signed[:user_id] = { :value => user.id,
                :expires => 2.weeks.from_now,
                :httponly => true,
                :domain => :all }
    cookies[:remember_token] = { :value => user.remember_token,
                :expires => 2.weeks.from_now,
                :httponly => true }
  end

  def find_token user_card
    tokens = Token.where(sp_card: user_card)
    tokens.select do |t| #puede tardar si no se borran los tokens.
      Token.authenticated?(t.token, cookies[:remember_token]) == true
    end
  end

  def forget(user)
    t = find_token user.sp_card
    t.update_attribute(:token, nil) #¿update or delete?
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(@current_user)
    debugger
    session.delete #está bien borrar toda la sesión?
    @current_user = nil
  end
end
