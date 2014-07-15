class CreateChosenVenues < ActiveRecord::Migration
  def change
    create_table :chosen_venues do |t|
      t.integer :lunch_week_id
      t.integer :venue_id

      t.timestamps
    end
  end
end
