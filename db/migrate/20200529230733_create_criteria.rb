class CreateCriteria < ActiveRecord::Migration[6.0]
  def change
    create_table :criteria do |t|
      t.string :type, null: false
      t.integer :start, null: false
      t.integer :end
    end
  end
end
