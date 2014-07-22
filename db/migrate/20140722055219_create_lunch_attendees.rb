class CreateLunchAttendees < ActiveRecord::Migration
  def change
    create_table :lunch_attendees do |t|
      t.integer :lunch_week_id
      t.integer :user_id

      t.timestamps
    end
  end
end
