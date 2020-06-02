class AddForeignKeyToRates < ActiveRecord::Migration[6.0]
  def change
    add_reference :rates, :customers, foreign_key: true
  end
end
