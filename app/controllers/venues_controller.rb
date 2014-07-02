class VenuesController < ApplicationController
  def index
    @venues=Venue.all
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
      render :json => 'ok'
    else
        #format.html { render :venue }
        #format.json { render json: @venue.errors, status: :unprocessable_entity }
      end
  end

  private

  def venue_params
    params.require(:venue).permit(:name, :description, :address)
  end

end