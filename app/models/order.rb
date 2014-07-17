class Order < ActiveRecord::Base

  belongs_to :user
  belongs_to :lunch_week

  validates_presence_of(:user_id, :lunch_week_id, :content)
end
