class LunchWeek < ActiveRecord::Base
  has_one :chosen_venue
  validates_presence_of :friday_date
end
