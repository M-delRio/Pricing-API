class AddForeignKeyToSurcharges < ActiveRecord::Migration[6.0]
  def change
    add_reference :surcharges, :rate, foreign_key: true  
  end
end
