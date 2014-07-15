class UserUtilityLog < ActiveRecord::Base
  belongs_to :user
  belongs_to :lunch_week
end
