class LunchAttendeesController < ApplicationController
  def set
    @lunchWeek = LunchWeek.new()
    @existing_lunch_week = @lunchWeek.getLunchWeek
    @attend_user = current_user.id
    @attend_status = params[:attend_status]
    @current_status = LunchAttendee.find_by(:lunch_week_id => @existing_lunch_week.id, :user_id => @attend_user)
    if @current_status.nil?
        LunchAttendee.create!(:lunch_week_id => @existing_lunch_week.id, :user_id => @attend_user, :status =>@attend_status)
    else
        @current_attendee = LunchAttendee.find_by(:lunch_week_id => @existing_lunch_week.id, :user_id => @attend_user)
        # @current_attendee.update_attribute(status, @attend_status)
        @current_attendee.status = @attend_status
        @current_attendee.save
    end
    render json: {ok: 'yes'}
  end

  def get
    @lunchWeek = LunchWeek.new()
    @existing_lunch_week = @lunchWeek.getLunchWeek
    @attend_user = current_user.id
    @current_status = LunchAttendee.find_by(:lunch_week_id => @existing_lunch_week.id, :user_id => @attend_user)
    if @current_status.nil?
      @attend_status = nil
    else
      @attend_status = @current_status.status
    end

    respond_to do |format|
      format.html {}
      format.json { render json: @attend_status }
    end
  end

end