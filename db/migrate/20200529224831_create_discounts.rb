class CreateDiscounts < ActiveRecord::Migration[6.0]
  def change
    create_table :discounts do |t|
      t.boolean :is_flat
      t.string :type
      t.integer :type_value
    end
  end
end
