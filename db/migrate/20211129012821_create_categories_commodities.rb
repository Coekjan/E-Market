class CreateCategoriesCommodities < ActiveRecord::Migration[5.2]
  def change
    create_table :categories_commodities do |t|
      t.references :category, foreign_key: true
      t.references :commodity, foreign_key: true
    end
  end
end
