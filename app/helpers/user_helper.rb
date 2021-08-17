module UserHelper
  def render_profile_picture(image)
    image.present? ? image.url : 'dummy.png'
  end
end
