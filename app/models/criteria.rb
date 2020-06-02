class Criteria < ApplicationRecord
  validates :discount_id, :criteria_type, :start, presence: true

  validates :start, numericality: { only_integer: true, greater_than_or_equal_to: 0}

  validates :criteria_type, inclusion: { in: ["range", "price"]}

  belongs_to :discount
end

