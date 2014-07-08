require 'rails_helper'

describe VenuesController do

  before do
    request.session[:user] = User.new(email: 'logged-in@thoughtworks.com')
  end

  describe "GET #index" do

    it "returns list ordered alphabetically" do
      venueB = Venue.create!({name: "B Name", description: "B Description", address: "B Address"})
      venueA = Venue.create!({name: "A Name", description: "A Description", address: "A Address"})
      venueC = Venue.create!({name: "C Name", description: "C Description", address: "C Address"})

      expected = [venueA, venueB, venueC].to_json
      get :index, :format => :json
      expect(response.body).to eq(expected)
    end

    it "should not return venues list out of alphabetical order" do
      venueB = Venue.create!({name: "B Name", description: "A Description", address: "A Address"})
      venueA = Venue.create!({name: "A Name", description: "B Description", address: "B Address"})

      notExpected = [venueB, venueA].to_json
      get :index, :format => :json
      expect(response.body).to_not eq(notExpected)
    end

  end
end