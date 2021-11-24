class AddRoleTypeToRole < ActiveRecord::Migration[5.2]
  def change
    add_column :roles, :role_type, :string
  end
end
