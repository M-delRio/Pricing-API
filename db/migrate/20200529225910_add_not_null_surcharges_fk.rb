class AddNotNullSurchargesFk < ActiveRecord::Migration[6.0]
  def change
    change_column_null :surcharges, :rate_id, false
  end
end
