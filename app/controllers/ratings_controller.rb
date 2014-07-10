class RatingsController < ApplicationController
  def set
    puts "got to set"
    @venue_id = params[:venue_id]
    @rating = params[:rating]
    #@user = current_user
    binding.pry
    Rating.where(:user_id => current_user.id, :venue_id => @venue_id).first_or_create!(:score => @rating)

    render json: {ok:'yes'}
    # respond_to do |format|
    #   format.json { render :jason => @rating }
  end
end
