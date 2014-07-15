class ChosenVenue < ActiveRecord::Base
  belongs_to :lunch_week
  belongs_to :venue
end
