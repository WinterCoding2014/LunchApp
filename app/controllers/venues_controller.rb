class VenuesController < ApplicationController
  def index
    @venues = Venue.sorted
    rated_venues = Venue.sorted.map { |v| {id: v.id, name: v.name, address: v.address, description: v.description, rating: 0} }
    score_map = {}
    Rating.where(:user_id => current_user).each { |r| score_map[r.venue_id] = r.score }
    rated_venues.each { |v| v[:rating] = score_map[v[:id]] unless score_map[v[:id]].nil? }
    respond_to do |format|
      format.html {}
      format.json { render json: rated_venues }
    end
  end

  def new
    @venue = Venue.new
  end

  def get_set_winner
    @day_week = Time.zone.now.strftime("%A")
    @time_hour = Time.zone.now.strftime("%H")
    if @day_week == "Friday"
      if @time_hour.to_i >= 11
        @existing_lunch_week = LunchWeek.find_by_friday_date(Time.zone.today.to_date)
        if @existing_lunch_week.nil?
          @existing_lunch_week = LunchWeek.create!(friday_date: Time.zone.today.to_date)
        end
        @existing_chosen_venue = ChosenVenue.find_by_lunch_week_id(@existing_lunch_week.id)
        if @existing_chosen_venue.nil?
          @venue = winner
          ChosenVenue.create!(lunch_week_id: @existing_lunch_week.id, venue_id: @venue.id)
        else
          @venue = Venue.find_by(id: @existing_chosen_venue.venue_id)
        end
      end
    end
    respond_to do |format|
      format.html {}
      format.json { render json: @venue }
    end
  end

  def winner
    clean_ratings =Rating.all.map { |r| {venue_id: r.venue_id, score: r.score} }
    group_ratings = clean_ratings.group_by { |r| r[:venue_id] }
    calculated_ratings = {}
    group_ratings.each do |key, value|
      sum = 0.0
      count = 0
      final_score = 0.0
      value.each do |b|
        sum = sum+b[:score]
        count = count +1
      end
      final_score = (sum/count) + Math.sqrt(count)
      calculated_ratings[key]= final_score
    end
    chosen_score=calculated_ratings.max_by { |k, v| v }
    chosen_venue = Venue.find(chosen_score[0])
    puts chosen_venue.id
    chosen_venue
  end

  def create

    @venue = Venue.new(venue_params)
    if @venue.save
      @venues = Venue.sorted
      render :json => @venues, :methods => [:rating]
    else
      render :json => {:errors => @venue.errors}, :status => 422
    end
  end

  private

  def venue_params
    puts params
    params.require(:venue).permit(:name, :description, :address)
  end

end