class CreateUserUtilityLogs < ActiveRecord::Migration
  def change
    create_table :user_utility_logs do |t|
      t.integer :user_id
      t.integer :lunch_week_id
      t.integer :difference

      t.timestamps
    end
  end
end
