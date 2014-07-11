require 'rails_helper'

describe VenuesController do

  before do
    user = User.new(email: 'logged-in@thoughtworks.com')
    user.save
    session[:user_id] = user.id
  end

  describe "GET #index" do

    it "returns list ordered alphabetically" do
      venueB = Venue.create!({name: "B Name", description: "B Description", address: "B Address"})
      venueA = Venue.create!({name: "A Name", description: "A Description", address: "A Address"})
      venueC = Venue.create!({name: "C Name", description: "C Description", address: "C Address"})

      venue_a_properties = {id:venueA.id,name:venueA.name,address:venueA.address,description:venueA.description,rating:0}
      venue_b_properties = {id:venueB.id,name:venueB.name,address:venueB.address,description:venueB.description,rating:0}
      venue_c_properties = {id:venueC.id,name:venueC.name,address:venueC.address,description:venueC.description,rating:0}

      expected = ActiveSupport::JSON.decode([venue_a_properties, venue_b_properties, venue_c_properties].to_json)
      get :index, :format => :json
      actual = ActiveSupport::JSON.decode(response.body)

      expect(actual).to eq(expected)
    end

  end
end