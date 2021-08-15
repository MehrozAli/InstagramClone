require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test 'a comment needs a body' do
    assert_not Comment.new(post: posts(:alice_post), user: users(:bruno)).valid?
  end

  test 'comments_count follows creates and deletes' do
    post = posts(:alice_post)

    comment = post.comments.create!(user: users(:bruno), comment_body: 'Warm tones')
    assert_equal 2, post.reload.comments_count

    comment.destroy!
    assert_equal 1, post.reload.comments_count
  end

  test 'post_owner is the id of the post author' do
    assert_equal users(:alice).id, comments(:carmen_on_alice).post_owner
  end
end
