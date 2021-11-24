class CreateShops < ActiveRecord::Migration[5.2]
  def change
    create_table :shops do |t|
      t.string :name
      t.text :introduction
      t.references :seller, foreign_key: true

      t.timestamps
    end
  end
end
