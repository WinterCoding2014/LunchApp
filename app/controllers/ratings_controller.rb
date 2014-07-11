class RatingsController < ApplicationController
  def set
    @venue_id = params[:venue_id]
    @rating = params[:rating]
    ratingObj = Rating.where(:user_id => current_user, :venue_id => @venue_id).first_or_create!(:score => @rating)
    ratingObj.update_attribute(:score, @rating)
    render json: {ok:'yes'}
  end
end
