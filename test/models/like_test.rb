require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  test 'creating and deleting a like moves the counter cache' do
    post = posts(:bruno_post)

    like = Like.create!(post: post, user: users(:carmen))
    assert_equal 1, post.reload.likes_count

    like.destroy!
    assert_equal 0, post.reload.likes_count
  end

  test 'a user can like a post only once' do
    duplicate = Like.new(post: posts(:alice_post), user: users(:carmen))

    assert_not duplicate.valid?
    assert_raises(ActiveRecord::RecordNotUnique) do
      Like.insert!({ post_id: posts(:alice_post).id, user_id: users(:carmen).id })
    end
  end
end
