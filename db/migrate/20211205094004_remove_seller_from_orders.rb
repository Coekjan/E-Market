class RemoveSellerFromOrders < ActiveRecord::Migration[5.2]
  def change
    remove_reference :orders, :seller, foreign_key: true
  end
end
