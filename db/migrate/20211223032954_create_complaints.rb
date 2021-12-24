class CreateComplaints < ActiveRecord::Migration[5.2]
  def change
    create_table :complaints do |t|
      t.references :customer, foreign_key: true
      t.references :seller, foreign_key: true
      t.text :content
      t.references :admin, foreign_key: true

      t.timestamps
    end
  end
end
