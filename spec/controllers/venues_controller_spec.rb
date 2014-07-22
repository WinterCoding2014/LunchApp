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
      venueB = Venue.create!({name: "B Name", description: "B Description", address: "B Address", menu_link: "http://www.B.com"})
      venueA = Venue.create!({name: "A Name", description: "A Description", address: "A Address", menu_link: "http://www.B.com"})
      venueC = Venue.create!({name: "C Name", description: "C Description", address: "C Address", menu_link: "http://www.B.com"})

      venue_a_properties = {id:venueA.id,name:venueA.name,address:venueA.address,description:venueA.description, menu_link:venueA.menu_link, rating:0}
      venue_b_properties = {id:venueB.id,name:venueB.name,address:venueB.address,description:venueB.description, menu_link:venueB.menu_link,rating:0}
      venue_c_properties = {id:venueC.id,name:venueC.name,address:venueC.address,description:venueC.description, menu_link:venueC.menu_link,rating:0}

      expected = ActiveSupport::JSON.decode([venue_a_properties, venue_b_properties, venue_c_properties].to_json)
      get :index, :format => :json
      actual = ActiveSupport::JSON.decode(response.body)

      expect(actual).to eq(expected)
    end
  end

  describe "GET #winner" do

    it "decide and return the chosen venue" do
      venueB = Venue.create!({name: "B Name", description: "B Description", address: "B Address", menu_link: "http://www.B.com"})
      venueA = Venue.create!({name: "A Name", description: "A Description", address: "A Address", menu_link: "http://www.A.com"})
      venueC = Venue.create!({name: "C Name", description: "C Description", address: "C Address", menu_link: "http://www.C.com"})

      ratingA1= Rating.create!({user_id:1,venue_id:1,score:1})
      ratingA2= Rating.create!({user_id:2,venue_id:1,score:1})
      ratingA3= Rating.create!({user_id:3,venue_id:1,score:7})
      ratingB1= Rating.create!({user_id:1,venue_id:2,score:3})
      ratingB2= Rating.create!({user_id:2,venue_id:2,score:4})
      ratingC1= Rating.create!({user_id:1,venue_id:3,score:7})
      ratingC2= Rating.create!({user_id:2,venue_id:3,score:5})


      expected = venueC
      expect(controller.send(:winner)).to eq(expected)
    end

    describe "GET #order_list"

    it "returns a list of orders for that lunch week" do

      this_lunch_week = LunchWeek.create!(friday_date: Time.zone.today)
      order_one = Order.create!(user_id: 1, lunch_week_id: 1, content: "Chicken and chips")
      order_two = Order.create!(user_id: 2, lunch_week_id: 1, content: "Chips and Gravy")

      user_a = User.find_by(id: order_one.user_id)
      user_b = User.find_by(id: order_two.user_id)

      total_hash = [{id: user_a.email, order: order_one.content},{id: user_b.email, order: order_two.content}]

      expected = ActiveSupport::JSON.decode(total_hash.to_json)
      get :order_list, :format => :json
      actual = ActiveSupport::JSON.decode(response.body)
      expect(actual).to eq(expected)
    end
  end
end