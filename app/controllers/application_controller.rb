# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  filter_parameter_logging :password


  helper_method :current_user
  helper_method :require_user
  helper_method :require_admin

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must login to access this page."
      redirect_to root_url
      return false
    end
  end
  
  def require_admin
    # If the current_user.id is something else then 1 that means somebody created an account. 
    # Let's raise so it doesn't go anywhere else. The application will be totally broke
    # We do not want to raise if somebody is not logged in so check if the current_user is blank
    raise "Sorry you can't be here" if !current_user.blank? && current_user.id != 1
    unless current_user
      store_location
      flash[:notice] = "You must login to do that."
      redirect_to root_url
      return false
    end
  end
end
