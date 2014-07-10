class Rating < ActiveRecord::Base
  belongs_to :user
  belongs_to :venue

  validates_presence_of :user_id, :message => "*must have a user id"
  validates_presence_of :venue_id, :message => "*must have a venue id"
  validates_numericality_of :score, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 5, :message => 'Score must be between 0-5'
end
