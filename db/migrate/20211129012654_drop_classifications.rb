class DropClassifications < ActiveRecord::Migration[5.2]
  def change
    drop_table :classifications
  end
end
