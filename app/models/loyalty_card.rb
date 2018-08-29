class LoyaltyCard < ApplicationRecord
  belongs_to :user

  validates_presence_of :point_total, :customer_id, :employee_id,
                        :loyalty_number, :password
  validates :point_total, :numericality => {:only_integer => true}
  validates_length_of :point_total, minimum: 1, maximum: 5
end
