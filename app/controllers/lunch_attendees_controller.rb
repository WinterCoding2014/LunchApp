class LunchAttendeesController < ApplicationController
  def set
    @lunchWeek = LunchWeek.new()
    @existing_lunch_week = @lunchWeek.getLunchWeek
    @attend_user = current_user.id
    @attend_status = params[:attend_status]
    @current_status = LunchAttendee.find_by(:lunch_week_id => @existing_lunch_week.id, :user_id => @attend_user)
    if @current_status.nil?
      if @attend_status == 'true'
        LunchAttendee.create!(:lunch_week_id => @existing_lunch_week.id, :user_id => @attend_user)
      end
    else
      if @attend_status == 'false'
        LunchAttendee.find_by(:lunch_week_id => @existing_lunch_week.id, :user_id => @attend_user).destroy
      end
    end
    render json: {ok: 'yes'}
  end

  def get
    @lunchWeek = LunchWeek.new()
    @existing_lunch_week = @lunchWeek.getLunchWeek
    @attend_user = current_user.id
    @current_status = LunchAttendee.find_by(:lunch_week_id => @existing_lunch_week.id, :user_id => @attend_user)
    if @current_status.nil?
      @attend_status = false
    else
      @attend_status = true
    end

    respond_to do |format|
      format.html {}
      format.json { render json: @attend_status }
    end
  end

end