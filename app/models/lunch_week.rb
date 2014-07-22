class LunchWeek < ActiveRecord::Base

  has_one :chosen_venue
  has_many :orders
  has_many :lunch_attendees
  has_many :user_utility_logs

  validates_presence_of :friday_date
  validates_uniqueness_of :friday_date
end
