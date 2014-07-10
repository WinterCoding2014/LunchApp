class Rating < ActiveRecord::Base
  belongs_to :user
  belongs_to :venue

  validates :score, :greater_than_or_equal_to %0, :less_than_or_equal_to %5
end
