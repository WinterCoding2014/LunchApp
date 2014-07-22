class LunchAttendeesController < ApplicationController
  def set
    @lunch_week = (LunchWeek.find_by(friday_date: Time.zone.today))
    @attend_user = current_user
    @attend_status = params[:attend_status]
    @current_status = LunchAttendee.find_by(:lunch_week_id => @lunch_week.id, :user_id => @attend_user)
    if @current_status.nil?
      if @attend_status
        LunchAttendee.create!(:lunch_week_id => @lunch_week.id, :user_id => @attend_user)
      end
    else
      if !@attend_status
        LunchAttendee.find_by(:lunch_week_id => @lunch_week.id, :user_id => @attend_user).destroy
      end
    end
    render json: {ok: 'yes'}
  end

  def get
    @lunch_week = (LunchWeek.find_by(friday_date: Time.zone.today))
    @attend_user = current_user
    @current_status = LunchAttendee.find_by(:lunch_week_id => @lunch_week.id, :user_id => @attend_user)
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