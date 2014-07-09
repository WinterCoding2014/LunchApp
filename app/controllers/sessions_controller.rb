class SessionsController < ApplicationController
  skip_filter :validate_session, :only => [:new, :create]

  def new

  end

  def create
    email = params[:shortname] + '@thoughtworks.com'
    user = find_or_create(email)

    if user
      session[:user] = user
      redirect_to '/'
    else
      render :new
    end
  end

  def destroy
    session[:user] = nil
    redirect_to '/'
  end

  private
  def find_or_create(email)
    user = User.find_by(email: email.downcase)
    unless user
      user = User.new(email: email)
      return nil unless user.save
    end
    user
  end

end
