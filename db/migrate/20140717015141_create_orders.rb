class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :user_id
      t.string :integer
      t.string :lunch_week_id
      t.string :integer
      t.string :content
      t.string :text

      t.timestamps
    end
  end
end
