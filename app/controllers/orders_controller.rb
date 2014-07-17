class OrdersController < ApplicationController
  def set
    @order_week = params[:lunch_week_id]
    @order_user = current_user
    @order_content = params[:content]

    @new_order = Order.where(:lunch_week_id => @order_week, :user_id => @order_user).first_or_create!(:content => @order_content)
    @new_order.update_attribute(:content, @order_content)
    render json: {ok: 'yes'}
  end
end
