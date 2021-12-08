class RemoveRoleFromAccounts < ActiveRecord::Migration[5.2]
  def change
    remove_reference :accounts, :role, foreign_key: true
  end
end
