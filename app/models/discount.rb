class Discount < ApplicationRecord
  validates :discount_type, :type_value, :rate_id, presence: true

  validates :type_value, numericality: { only_integer: true, greater_than_or_equal_to: 0}

  validates :discount_type, inclusion: { in: ["percentage", "monetary"]}
   
  belongs_to :rate
  has_one :criteria, dependent: :destroy
end
