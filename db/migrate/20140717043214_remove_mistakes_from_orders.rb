class RemoveMistakesFromOrders < ActiveRecord::Migration
  def change
    self.up
    remove_column :orders, :integer
    remove_column :orders, :integer
    remove_column :orders, :text

    change_column :orders, :user_id, :integer
    change_column :orders, :lunch_week_id, :integer
    change_column :orders, :content, :text

  end
end
