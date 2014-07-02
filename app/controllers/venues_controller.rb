class VenuesController < ApplicationController
def index
	@venues=Venue.all
	respond_to do |format|
		format.html {}
		format.json { render :json =>@venues}
	end
end

def new
	@venue = Venue.new
end

def create
	@venue = Venue.new(params[:venue])
	if @venue.save
		format.html {redirect_to @venue, notice: 'Venue has been created'}
		format.js {}
		format.json {render json: @venue, status: created, location: @venue}
	else
		format.html {render :venue}
		format.json {render json: @venue.errors, status: :unprocessable_entity}
	end
end

end