class VenuesController < ApplicationController
  def index
    @rated_venues = ratings
    respond_to do |format|
      format.html {}
      format.json { render json: @rated_venues }
    end
  end

  def ratings
    @venues = Venue.sorted
    score_map = {}
    rated_venues = Venue.sorted.map { |v| {id: v.id, name: v.name, address: v.address, description: v.description, menu_link: v.menu_link, rating: 0} }
    Rating.where(:user_id => current_user).each { |r| score_map[r.venue_id] = r.score }
    rated_venues.each { |v| v[:rating] = score_map[v[:id]] unless score_map[v[:id]].nil? }
    rated_venues
  end

  def new
    @venue = Venue.new
  end



  def get_set_winner
    @day_week = Time.zone.now.strftime("%A")
    @time_hour = Time.zone.now.strftime("%H")
    if @day_week == "Wednesday"
      if @time_hour.to_i >= 8
        @lunchWeek = LunchWeek.new()
        @existing_lunch_week = @lunchWeek.getLunchWeek
        @existing_chosen_venue = ChosenVenue.find_by_lunch_week_id(@existing_lunch_week.id)
        if @existing_chosen_venue.nil?
          @venue = winner(@existing_lunch_week.id)
          saveUserUtility(@venue.id, @existing_lunch_week.id)
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

  def winner(lunch_week_id)
    lunch_attendees = LunchAttendee.where(:lunch_week_id => lunch_week_id)
    attendees = Array.new
    lunch_attendees.each do |l|
      attendees.push(l.user_id)
    end
    dirty_ratings = Rating.where(:user_id => attendees)

    clean_ratings = dirty_ratings.all.map { |r| {venue_id: r.venue_id, score: r.score} }
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
    chosen_venue
  end

  def saveUserUtility (lunch_week_id, venue_id)
    all_users = User.all
    all_users.each do |u|
      @existing_score = Rating.find_by(venue_id: venue_id, user_id: u.id)
      if @existing_score != nil
        @users_difference = 7 - @existing_score.score
        UserUtilityLog.create!(user_id: u.id, lunch_week_id: lunch_week_id, difference: @users_difference)
      end
    end
  end


  def order_list
    @this_lunch_week = LunchWeek.find_by(friday_date: Time.zone.today)
    @this_weeks_orders = Order.where(lunch_week_id: @this_lunch_week.id)
    clean_orders = @this_weeks_orders.each.map{ |o| {id: o.user_id, order: o.content}}

    clean_orders.each do |key, value|
      name = (User.find_by(id: key[:id])).email
      key[:id] = name
    end

    respond_to do |format|
      format.html {}
      format.json { render json: clean_orders }
    end

  end

  def create

    @venue = Venue.new(venue_params)
    if @venue.save
      @venues = ratings
      render :json => @venues
    else
      render :json => {:errors => @venue.errors}, :status => 422
    end
  end

  private

  def venue_params
    puts params
    params.require(:venue).permit(:name, :description, :address, :menu_link)
  end

end