class Venue < ActiveRecord::Base
  validates_presence_of :name, :message => "Name cannot be blank"
  validates_presence_of :description, :message => "Description cannot be blank"
  validates_presence_of :address, :message => "Address cannot be blank"

  scope :sorted, -> { order("upper(name)") }

end
