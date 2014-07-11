class VenuesController < ApplicationController
  def index
    @venues = Venue.sorted
    rated_venues = Venue.sorted.map { |v| { id: v.id, name: v.name, address: v.address, description: v.description, rating: 0 } }
    score_map = {}
    Rating.where(:user_id => current_user).each { |r| score_map[r.venue_id] = r.score }
    rated_venues.each { |v|  v[:rating] = score_map[v[:id]] unless score_map[v[:id]].nil? }
    respond_to do |format|
      format.html {}
      format.json {render json: rated_venues }
      #format.json { render :json => @venues, :methods => [:rating] }
    end
  end


  def the_thing
    rated_venues = Venue.sorted.map { |v| { id: v.id, name: v.name, address: v.address, description: v.description, rating: 0 } }
    score_map = {}
    Ratings.find_by_user(current_user).each { |r| score_map[r.venue_id] = r.score }
    rated_venues.each { |r| r.rating = score_map[r.id] unless score_map[r.id].nil? }
    render json: rated_venues
  end





  def new
    @venue = Venue.new
  end

  def create
    @venue = Venue.new(venue_params)
    if @venue.save
      @venues = Venue.sorted
      render :json => @venues, :methods => [:rating]
    else
      render :json => { :errors => @venue.errors }, :status => 422
    end
  end

  private

  def venue_params
    puts params
    params.require(:venue).permit(:name, :description, :address)
  end

end