class VenuesController < ApplicationController
def index
	@venues=Venue.all
	render :json =>@venues
end
end