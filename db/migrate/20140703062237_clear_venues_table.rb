class ClearVenuesTable < ActiveRecord::Migration
  def change
    Venue.destroy_all if Rails.env.production?
  end
end
