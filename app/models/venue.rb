class Venue < ActiveRecord::Base

  has_many :ratings
  has_many :chosen_venues
  validates_presence_of :name, :message => "*name cannot be blank"
  validates_presence_of :description, :message => "*description cannot be blank"
  validates_presence_of :address, :message => "*address cannot be blank"
  validates_format_of :menu_link, :with => /\A(^$|(http:\/\/.*))\z/i, :message => "The menu link must start with http://"

  scope :sorted, -> { order("upper(name)") }

  def rating
    @_rating = 0
    @_rating
  end
end
