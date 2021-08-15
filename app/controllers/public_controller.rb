class PublicController < ApplicationController
  def home
    redirect_to home_path if user_signed_in?
  end

  def render_404
    render_not_found
  end
end
