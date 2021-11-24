class RemoveTypeFromRole < ActiveRecord::Migration[5.2]
  def change
    remove_column :roles, :type, :string
  end
end
