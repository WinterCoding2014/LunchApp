class ApplicationController < ActionController::Base
  before_filter :validate_session

    # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def validate_session
    redirect_to new_session_path unless session[:user].present?
  end
end
