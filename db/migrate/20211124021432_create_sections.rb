class CreateSections < ActiveRecord::Migration[5.2]
  def change
    create_table :sections do |t|
      t.integer :grade

      t.timestamps
    end
  end
end
