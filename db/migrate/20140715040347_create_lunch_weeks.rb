class CreateLunchWeeks < ActiveRecord::Migration
  def change
    create_table :lunch_weeks do |t|
      t.date :friday_date

      t.timestamps
    end
  end
end
