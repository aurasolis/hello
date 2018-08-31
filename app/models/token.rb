class Token < ApplicationRecord
  belongs_to :user

  validates :sp_card,  presence: true, length: { maximum: 12 }
	validates :token, presence: true, uniqueness: true

end
