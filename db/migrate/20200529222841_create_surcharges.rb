class CreateSurcharges < ActiveRecord::Migration[6.0]
  def change
    create_table :surcharges do |t|
      t.string :item_property, null: false
      t.string :type, null: false
      t.integer :type_value, null: false
    end
  end
end
