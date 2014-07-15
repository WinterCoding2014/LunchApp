class CreateLunchWeeks < ActiveRecord::Migration
  def change
    drop_table :lunch_weeks
    create_table :lunch_weeks do |t|
      t.date :friday_date

      t.timestamps
    end
  end
end
