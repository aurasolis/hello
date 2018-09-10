class Token < ApplicationRecord
  belongs_to :user

  validates :sp_card,  presence: true, length: { maximum: 12 }
	validates :token, presence: true, uniqueness: true

  def self.new_token
		SecureRandom.urlsafe_base64
	end

  def self.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.generate_token user
		t = Token.new(:token => Token.new_token)
    user.remember_token = t.token
    t.update_attribute :token, Token.digest(user.remember_token)
		t.update_attribute :sp_card, user.sp_card
  end

  def self.authenticated? token, remember_token
    return false if token.nil?
    BCrypt::Password.new(token).is_password?(remember_token)
  end
end
