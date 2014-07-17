class RemoveMistakesFromOrders < ActiveRecord::Migration

  def change
    drop_table :orders

    create_table :orders do |t|
      t.integer :user_id
      t.integer :lunch_week_id
      t.text :content

      t.timestamps
    end
  end
end
