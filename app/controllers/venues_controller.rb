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
    puts @day_week
    @time_hour = Time.zone.now.strftime("%H")
    puts @time_hour
    if @day_week == "Friday"
      if @time_hour.to_i >= 11
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

  def grab_weekly_ratings(lunch_week_id)
    @lunch_attendees = LunchAttendee.where(:lunch_week_id => lunch_week_id, :status => true)
    @prior_unhappy_scores = grab_unhappy_users(lunch_week_id-1)
    @attendees = Array.new
    @lunch_attendees.each do |l|
      @attendees.push(l.user_id)
      @existing_user_flag = @prior_unhappy_scores.include?(l.user_id)
      if @existing_user_flag == true
        @attendees.push(l.user_id)
      end
    end

    @dirty_ratings = Array.new
    @attendees.each do |a|
      @this_users_ratings = Rating.where(:user_id => a)
      @this_users_ratings.each do |r|
        @dirty_ratings.push(r)
      end
    end
    @clean_ratings = @dirty_ratings.each.map { |r| {venue_id: r.venue_id, score: r.score} }
    @clean_ratings
  end


  def calculate_venue_scores(weekly_ratings)
    @group_ratings = weekly_ratings.group_by { |r| r[:venue_id] }
    @calculated_ratings = {}
    @group_ratings.each do |key, value|
      sum = 0.0
      count = 0
      @final_score = 0.0
      value.each do |b|
        sum = sum+b[:score]
        count = count +1
      end
      @final_score = (sum/count) + Math.sqrt(count)
      @calculated_ratings[key]= @final_score
    end
    @calculated_ratings
  end

  def pick_venue(venue_ratings, lunch_week_id)
    @chosen_score=venue_ratings.max_by { |k, v| v }
    @chosen_venue = Venue.find(@chosen_score[0])
    if lunch_week_id > 1
      @last_winner_entry = ChosenVenue.find_by(lunch_week_id: (lunch_week_id - 1))
      if @last_winner_entry != nil
        if @chosen_venue.id == @last_winner_entry.venue_id
          venue_ratings.delete(@chosen_score[0])
          @chosen_score=venue_ratings.max_by { |k, v| v }
          @chosen_venue = Venue.find(@chosen_score[0])
        end
      end
    end
    @chosen_venue
  end

  def winner(lunch_week_id)
    @weekly_ratings = grab_weekly_ratings(lunch_week_id)
    @venue_ratings = calculate_venue_scores(@weekly_ratings)
    @chosen_venue = pick_venue(@venue_ratings, lunch_week_id)
    @chosen_venue
  end

  def am_i_unhappy
    @im_happy = true
    @my_id = current_user.id
    @lunch_week = LunchWeek.new()
    @this_lunch_week = @lunch_week.getLunchWeek()
    @unhappy_users = grab_unhappy_users(@this_lunch_week.id)
    if @unhappy_users.include?(@my_id)
      @im_happy = false
    end
    respond_to do |format|
      format.html {}
      format.json { render json: @im_happy }
    end
  end

  def grab_unhappy_users(lunch_week_id)
    @unhappy_users = Array.new
    if lunch_week_id >= 1
      @unhappy_scores = UserUtilityLog.where(lunch_week_id: (lunch_week_id))
      @unhappy_scores.each do |s|
                if s.difference == 6
                  @unhappy_users.push(s.user_id)
                end
      end
      if @unhappy_scores.length == 0
          @unhappy_scores.each do |s|
            if s.difference == 4
              @unhappy_users.push(s.user_id)
            end
          end
      end
    end
    @unhappy_users
  end

  def saveUserUtility (venue_id, lunch_week_id)
    @lunch_attendees = LunchAttendee.where(:lunch_week_id => lunch_week_id, :status => true)
    @lunch_attendees.each do |u|
      @existing_score = Rating.find_by(venue_id: venue_id, user_id: u.user_id)
      if @existing_score != nil
        @users_difference = 7 - @existing_score.score
        UserUtilityLog.create!(user_id: u.user_id, lunch_week_id: lunch_week_id, difference: @users_difference)
      end
    end
  end


  def order_list
    @this_lunch_week = LunchWeek.find_by(friday_date: Time.zone.today)
    @this_weeks_orders = Order.where(lunch_week_id: @this_lunch_week.id)
    clean_orders = @this_weeks_orders.each.map { |o| {id: o.user_id, order: o.content} }

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