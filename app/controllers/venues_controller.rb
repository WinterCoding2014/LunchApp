class VenuesController < ApplicationController
  def index
    @venues=Venue.all.order("name")
    respond_to do |format|
      format.html {}
      format.json { render :json => @venues }
    end
  end

  def new
    @venue = Venue.new
  end

  def create
    @venue = Venue.new(venue_params)
    if @venue.save
      @venues=Venue.all.order("name")
      render :json => @venues
    end
    #render json: @venue.all.order("name") if @venue.save
  end

  private

  def venue_params
    params.require(:venue).permit(:name, :description, :address)
  end

end