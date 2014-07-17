require 'rails_helper'

describe OrdersController do

  before do
    userA = User.new(email: 'logged-inA@thoughtworks.com')
    userA.save
    session[:user_id] = userA.id
  end

  describe "PUT #set" do

    it "saves order for that week and returns OK" do

      venue_A = Venue.create!({name: "A Name", description: "A Description", address: "A Address", menu_link: "http://www.A.com"})
      this_lunch_week = LunchWeek.create!(:friday_date => Time.zone.today)
      order_content = "1 x Chicken and Chips"
      the_order = Order.create!(:user_id => session[:user_id], :lunch_week_id => 1, :content => order_content)

      expected = {ok: 'yes'}.to_json
      put :set, :format => :json, :content => order_content
      actual = response.body
      expect(actual).to eq(expected)
    end
  end

end