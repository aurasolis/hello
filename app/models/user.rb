class User < ApplicationRecord
	attr_accessor :remember_token, :reset_token, :email_confirmation
	has_many :tokens
	before_save { self.email = email.downcase }

	validates :first_name,
						presence: true,
						length: { maximum: 50 }
	validates :last_name,
						presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
										length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
	validate :check_email

	def check_email
		errors.add(:email_confirmation,:different, "Emails do not match") if email == email_confirmation
	end

	def self.find_or_create_from_auth_hash(auth)
		where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
			user.provider = auth.provider
			user.uid = auth.uid
			user.first_name = auth.info.first_name || auth.info.name.split(' ')[0]
			user.last_name = auth.info.last_name|| auth.info.name.split(' ')[1]
			user.email = auth.info.email || auth.extra.raw_info.userPrincipalName
			user.picture = auth.info.image
			user.save!
		end
	end

	def self.find_or_create_from_params(params)
		where(email: params[:email]).first_or_initialize.tap do |user|
			user.first_name = params[:first_name]
			user.last_name = params[:last_name]
			user.email = params[:email]
			user.birthday = params[:birthday]
			user.save!
		end
	end

end
