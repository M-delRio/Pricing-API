class AddNotNullRatesFk < ActiveRecord::Migration[6.0]
  def change
    change_column_null :rates, :customer_id, false
  end
end
