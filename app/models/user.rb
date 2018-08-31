class User < ApplicationRecord
	attr_accessor :remember_token
	has_many :token
	before_save { self.email = email.downcase }

	validates :first_name,  presence: true, length: { maximum: 50 }
	validates :last_name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
										uniqueness: { case_sensitive: false }

	def self.find_or_create_from_auth_hash(auth)
		where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
			user.provider = auth.provider
			user.uid = auth.uid
			user.first_name = auth.info.first_name
			user.last_name = auth.info.last_name
			user.email = auth.info.email || auth.extra.raw_info.userPrincipalName
			user.picture = auth.info.image
			user.save!
		end
	end

	def User.new_token
		SecureRandom.urlsafe_base64
	end

	def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.generate_token(user)
		t = Token.new(:token => User.new_token)
    user.remember_token = t.token
    t.update_attribute(:token, User.digest(user.remember_token))
		t.update_attribute(:sp_card, user.sp_card)
  end

  def authenticated?(remember_token)
    return false if token.nil?
    BCrypt::Password.new(token).is_password?(remember_token)
  end

  def forget
    update_attribute(:token, nil)
  end
end
