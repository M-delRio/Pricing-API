class Customer < ApplicationRecord
  has_one :rate, dependent: :destroy
end
