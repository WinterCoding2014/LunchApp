require 'rails_helper'

describe VenuesController do

  describe "GET #index" do

    it "returns list ordered alphabetically" do
      venueB = Venue.create!({name: "B Name"})
      venueA = Venue.create!({name: "A Name"})
      venueC = Venue.create!({name: "C Name"})

      expected = [venueA, venueB, venueC].to_json
      get :index, :format => :json
      expect(response.body).to eq(expected)
    end

  end
end