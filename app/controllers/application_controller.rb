class ApplicationController < ActionController::Base
  include Pundit::Authorization
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
    if request.format.html? && !request.xhr?
      redirect_back_or_to home_path, alert: 'You are not authorized to perform this action.'
    else
      head :forbidden
    end
  end

  def render_not_found
    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
  end
end
