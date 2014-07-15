class UserUtilityLog < ActiveRecord::Base
  belongs_to :user
  belongs_to :lunch_week
  validates_presence_of :difference
end
