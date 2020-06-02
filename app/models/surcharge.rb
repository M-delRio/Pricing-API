class Surcharge < ApplicationRecord
  validates :rate_id, :item_property, :surcharge_type, :type_value, presence: true

  validates :type_value, numericality: { only_integer: true, greater_than_or_equal_to: 0}

  validates :item_property, inclusion: { in: ["volume", "value"]}

  validates :surcharge_type, inclusion: { in: ["percentage", "monetary"]}

  belongs_to :rate
end
