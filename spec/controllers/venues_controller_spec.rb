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

      expected = ActiveSupport::JSON.decode([venueA, venueB, venueC].to_json)
      get :index, :format => :json
      actual = ActiveSupport::JSON.decode(response.body).each { |d| d.delete('rating') }

      expect(actual).to eq(expected)
    end

  end
end