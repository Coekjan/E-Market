class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :count
      t.decimal :price
      t.boolean :done
      t.references :commodity, foreign_key: true
      t.references :seller, foreign_key: true

      t.timestamps
    end
  end
end
