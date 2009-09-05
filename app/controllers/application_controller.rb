# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  filter_parameter_logging :password


  helper_method :current_user
  helper_method :has_admin
  
  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  
  def has_admin
    return @has_admin if defined?(@has_admin)
    current_user = current_user_session && current_user_session.record
    if current_user.has_role? :admin == true
      @has_admin = true
    end
  end

end
