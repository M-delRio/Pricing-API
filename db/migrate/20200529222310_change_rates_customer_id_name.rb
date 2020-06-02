class ChangeRatesCustomerIdName < ActiveRecord::Migration[6.0]
  def change
    change_table :rates do |t|
      t.rename :customers_id, :customer_id
    end
  end
end
