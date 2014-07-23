require 'rails_helper'

describe LunchAttendeesController do

  before do
    userA = User.new(email: 'logged-inA@thoughtworks.com')
    userA.save
    session[:user_id] = userA.id
  end

  describe "PUT #set" do

    it "saves in status of current user and returns ok" do

      @this_lunch_week = LunchWeek.create!(:friday_date => Time.zone.today)

      expected = {ok: 'yes'}.to_json
      put :set, :format => :json, :attend_status => true
      actual = response.body
      expect(actual).to eq(expected)
    end
    it "delete in status of current user if not attending and returns ok" do

      @this_lunch_week = LunchWeek.create!(:friday_date => Time.zone.today)
      @existing_lunch_attendee = LunchAttendee.create!(:user_id => session[:user_id], :lunch_week_id => 1, :status =>true)

      expected = {ok: 'yes'}.to_json
      put :set, :format => :json, :attend_status => false
      actual = response.body
      expect(actual).to eq(expected)
    end
  end



  describe "GET #get" do

    it "returns true if user is in" do

      @this_lunch_week = LunchWeek.create!(:friday_date => Time.zone.today)
      @existing_lunch_attendee = LunchAttendee.create!(:user_id => session[:user_id], :lunch_week_id => 1,:status =>true)
      if !@existing_lunch_attendee.nil?
        @current_status = true
      else
        @current_status = false
      end

      expected = @current_status.to_json
      get :get, :format => :json
      actual = response.body
      expect(actual).to eq(expected)
    end
    it "return false if user not in" do
      @this_lunch_week = LunchWeek.create!(:friday_date => Time.zone.today)
      @existing_lunch_attendee = LunchAttendee.create!(:user_id => session[:user_id], :lunch_week_id => 1,:status =>false)
      @current_status = false

      expected = @current_status.to_json
      get :get, :format => :json
      actual = response.body
      expect(actual).to eq(expected)
    end
  end
end