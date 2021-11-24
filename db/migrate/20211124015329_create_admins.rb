class CreateAdmins < ActiveRecord::Migration[5.2]
  def change
    create_table :admins do |t|
      t.references :account, foreign_key: true

      t.timestamps
    end
  end
end
