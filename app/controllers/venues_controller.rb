class VenuesController < ApplicationController
  def index
    @venues = Venue.sorted
    respond_to do |format|
      format.html {}
      format.json { render :json => @venues, :methods => [:rating] }
    end
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