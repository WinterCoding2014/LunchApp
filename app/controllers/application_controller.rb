class ApplicationController < ActionController::Base
  before_filter :validate_session

  protect_from_forgery with: :exception

  def validate_session
    redirect_to new_session_path if current_user.nil?
  end

  def current_user
    return nil unless session[:user_id]
    User.find(session[:user_id])
  end

  def login (user)
    if user.nil?
      session[:user_id] = nil
    else
        session[:user_id] = user.id
    end
  end

end
