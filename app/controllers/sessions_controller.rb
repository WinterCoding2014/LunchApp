class SessionsController < ApplicationController
  skip_filter :validate_session, :only => [:new, :create]

  def new

  end

  def create
    session[:logged_in] = true
    redirect_to '/'
  end

  def destroy
    session[:logged_in] = false
    redirect_to '/'
  end

end
