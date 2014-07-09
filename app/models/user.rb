class User < ActiveRecord::Base

  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  before_save :drop_the_case

  private
    def drop_the_case
      self.email.downcase!
    end

end
