class CreateCommodities < ActiveRecord::Migration[5.2]
  def change
    create_table :commodities do |t|
      t.string :name
      t.text :introduction
      t.decimal :price
      t.references :shop, foreign_key: true
      t.references :categories, foreign_key: true

      t.timestamps
    end
  end
end
