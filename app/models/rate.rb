class Rate < ApplicationRecord
  validates :customer_id, presence: true

  belongs_to :customer
  has_one :surcharge, dependent: :destroy
  has_many :discounts, dependent: :destroy
end
