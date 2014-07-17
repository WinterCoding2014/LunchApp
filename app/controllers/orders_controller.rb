class OrdersController < ApplicationController
  def set
    puts "got to set function"
    @order_week = (LunchWeek.find_by(friday_date: Time.zone.today))
    @order_user = current_user
    @order_content = params[:content]

    @new_order = Order.where(:lunch_week_id => @order_week.id, :user_id => @order_user).first_or_create!(:content => @order_content)
    @new_order.update_attribute(:content, @order_content)
    render json: {ok: 'yes'}
  end

  def get
    @order_week = LunchWeek.find_by(friday_date: Time.zone.today)
    @order_user = current_user
    @order = Order.find_by(:lunch_week_id => @order_week.id, :user_id => @order_user)
    respond_to do |format|
      format.html {}
      format.json { render json: @order }
    end
  end
end
