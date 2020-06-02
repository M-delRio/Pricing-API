class RenameTypeColNames < ActiveRecord::Migration[6.0]
  def change
    rename_column :discounts, :type, :discount_type
    rename_column :surcharges, :type, :surcharge_type
    rename_column :criteria, :type, :criteria_type
  end
end
