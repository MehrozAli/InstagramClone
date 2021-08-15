class LikeCreator
  def initialize(post, post_id, user_id)
    @post = post
    @post_id = post_id
    @current_user = user_id
  end

  def execute
    if @post.present?
      @post.destroy
      false
    elsif Like.create(post_id: @post_id, user_id: @current_user)
      true
    end
  end
end
