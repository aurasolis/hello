module SessionsHelper

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

  def find_token user_card #returns array
    tokens = Token.where(sp_card: user_card)
    tokens.select do |t| #puede tardar si no se borran los tokens.
      Token.authenticated?(t.token, cookies[:remember_token]) == true
    end
  end

  def forget(user)
    t = find_token user.sp_card
    t[0].update_attribute(:token, nil) unless t.empty? #¿update or delete?
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(@current_user)
    @current_user = nil
  end
end
