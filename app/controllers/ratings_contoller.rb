class RatingsController < ApplicationController

  def set
    @venue_id = params[:venue][:id]
    @rating = params[:rating]
    Rating.where(:user_id => current_user.id, :venue_id => @venue_id.first_or_create!(:score => @rating))
  end

end