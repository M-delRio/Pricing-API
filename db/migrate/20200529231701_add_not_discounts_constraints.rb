class AddNotDiscountsConstraints < ActiveRecord::Migration[6.0]
  def change
    change_column_null :discounts, :is_flat, false
    change_column_null :discounts, :type_value, false
  end
end
