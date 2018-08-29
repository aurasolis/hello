class User < ApplicationRecord
	has_one :loyalty_card
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
end
