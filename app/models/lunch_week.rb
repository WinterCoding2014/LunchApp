class LunchWeek < ActiveRecord::Base

  has_one :chosen_venue
  has_many :orders
  has_many :lunch_attendees
  has_many :user_utility_logs

  validates_presence_of :friday_date
  validates_uniqueness_of :friday_date

  def getLunchWeek
    @existing_lunch_week = LunchWeek.find_by_friday_date(Time.zone.now.to_date)
    if @existing_lunch_week.nil?
      @existing_lunch_week = LunchWeek.create!(friday_date: Time.zone.now.to_date)
    end
    @existing_lunch_week
  end


end
