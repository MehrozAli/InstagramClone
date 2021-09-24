class ApplicationController < ActionController::Base
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username first_name last_name email password])
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: %i[username first_name last_name email profileImg profileImg_cache
                                               isPrivate])
  end

  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to(request.referrer || home_path)
  end

  def render_not_found
    render file: "#{Rails.root}/public/404.html", status: 404
  end
end
