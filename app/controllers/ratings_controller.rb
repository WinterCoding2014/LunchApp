class RatingsController < ApplicationController
  def set
    puts "got to set"
    @venue_id = params[:venue_id]
    @rating = params[:rating]
    puts "New rating is " + @rating
    ratingObj = Rating.where(:user_id => current_user, :venue_id => @venue_id).first_or_create!(:score => @rating)
    ratingObj.update_attribute(:score, @rating)
    puts "Score for that rating is "
    puts Rating.find_by(:user_id => current_user, :venue_id => @venue_id).score

    render json: {ok:'yes'}
    # respond_to do |format|
    #   format.json { render :jason => @rating }
  end
end
