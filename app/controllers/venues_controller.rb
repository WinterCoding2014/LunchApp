class VenuesController < ApplicationController
  def index
    @venues = Venue.sorted
    rated_venues = Venue.sorted.map { |v| {id: v.id, name: v.name, address: v.address, description: v.description, rating: 0} }
    score_map = {}
    Rating.where(:user_id => current_user).each { |r| score_map[r.venue_id] = r.score }
    rated_venues.each { |v| v[:rating] = score_map[v[:id]] unless score_map[v[:id]].nil? }
    respond_to do |format|
      format.html {}
      format.json { render json: rated_venues }
    end
  end

  def new
    @venue = Venue.new
  end

  def winner
    clean_ratings =Rating.all.map{|r|{venue_id:r.venue_id, score:r.score} }
    clean_ratings.group_by{ |r| r.venue_id}
  end

  def create
    @venue = Venue.new(venue_params)
    if @venue.save
      @venues = Venue.sorted
      render :json => @venues, :methods => [:rating]
    else
      render :json => {:errors => @venue.errors}, :status => 422
    end
  end

  private

  def venue_params
    puts params
    params.require(:venue).permit(:name, :description, :address)
  end

end