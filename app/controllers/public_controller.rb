class PublicController < ApplicationController
  def home; end

  def render_404
    render_not_found
  end
end
