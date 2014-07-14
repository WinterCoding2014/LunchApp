require 'rails_helper'

describe VenuesController do

  before do
    userA = User.new(email: 'logged-inA@thoughtworks.com')
    userB = User.new(email: 'logged-inB@thoughtworks.com')
    userC = User.new(email: 'logged-inC@thoughtworks.com')
    userA.save
    userB.save
    userC.save
    session[:user_id] = userA.id
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

  describe "GET #winner" do

    it "decide and return the chosen venue" do
      venueB = Venue.create!({name: "B Name", description: "B Description", address: "B Address"})
      venueA = Venue.create!({name: "A Name", description: "A Description", address: "A Address"})
      venueC = Venue.create!({name: "C Name", description: "C Description", address: "C Address"})

      ratingA1= Rating.create!({user_id:1,venue_id:1,score:1})
      ratingA2= Rating.create!({user_id:2,venue_id:1,score:1})
      ratingA3= Rating.create!({user_id:3,venue_id:1,score:7})
      ratingB1= Rating.create!({user_id:1,venue_id:2,score:3})
      ratingB2= Rating.create!({user_id:2,venue_id:2,score:4})
      ratingC1= Rating.create!({user_id:1,venue_id:3,score:7})
      ratingC2= Rating.create!({user_id:2,venue_id:3,score:5})

      expected = venueC.to_json
      get :winner, :format => :json
      actual = response.body
      expect(actual).to eq(expected)
    end
  end
end