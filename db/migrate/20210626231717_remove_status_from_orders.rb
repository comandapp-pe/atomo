# typed: true
class RemoveStatusFromOrders < ActiveRecord::Migration[6.1]
  def change
    remove_column :orders, :status, :integer
  end
end