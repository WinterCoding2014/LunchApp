class VenuesController < ApplicationController
def index
	@venues=Venue.all
	#render :json =>@venues
	respond_to do |format|
		format.html {}
		format.json { render :json =>@venues}
	end
end
end