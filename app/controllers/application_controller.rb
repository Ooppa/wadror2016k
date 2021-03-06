class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :is_admin

  def current_user
    return nil if session[:user_id].nil?
    User.find(session[:user_id])
  end

  def is_admin
    return nil if session[:user_id].nil?
    User.find(session[:user_id]).admin
  end

  def ensure_that_signed_in
    redirect_to signin_path, notice:'you should be signed in' if current_user.nil?
  end
end
