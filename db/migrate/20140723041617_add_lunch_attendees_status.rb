class AddLunchAttendeesStatus < ActiveRecord::Migration
  def change
    change_table :lunch_attendees do |l|
      l.boolean :status
    end
  end
end
