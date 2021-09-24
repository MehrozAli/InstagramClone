module UserHelper
  def render_profile_picture(image)
    image.present? ? image.url : 'dummy_user.png'
  end

  def can_edit_profile?(profile_id)
    user_signed_in? && current_user.id == profile_id
  end

  def private?(user)
    current_user.id != user.id && user.isPrivate && !current_user.following?(user.id)
  end
end
