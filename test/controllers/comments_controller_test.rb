require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:alice_post)
  end

  test 'a signed-out visitor cannot comment' do
    assert_no_difference 'Comment.count' do
      post post_comments_path(@post), params: { comment: { comment_body: 'hello' } }
    end
    assert_redirected_to new_user_session_path
  end

  test 'a comment always belongs to the signed-in user, whatever user_id is sent' do
    sign_in users(:bruno)

    assert_difference -> { @post.reload.comments_count }, 1 do
      post post_comments_path(@post), xhr: true,
                                       params: { comment: { comment_body: 'Nice', user_id: users(:carmen).id } }
    end
    assert_response :success
    assert_equal users(:bruno), Comment.order(:id).last.user
  end

  test 'nobody can comment on a private post they cannot see' do
    sign_in users(:alice)

    assert_no_difference 'Comment.count' do
      post post_comments_path(posts(:bruno_post)), xhr: true, params: { comment: { comment_body: 'peek' } }
    end
    assert_response :forbidden
  end

  test 'the post owner cannot rewrite a visitor\'s comment' do
    sign_in users(:alice)
    comment = comments(:carmen_on_alice)

    patch post_comment_path(@post, comment), xhr: true, params: { comment: { comment_body: 'edited by owner' } }

    assert_response :forbidden
    assert_equal 'Lovely light on the ridge.', comment.reload.comment_body
  end

  test 'the author can edit their comment' do
    sign_in users(:carmen)
    comment = comments(:carmen_on_alice)

    patch post_comment_path(@post, comment), xhr: true, params: { comment: { comment_body: 'Even better up close' } }

    assert_response :success
    assert_equal 'Even better up close', comment.reload.comment_body
  end

  test 'the post owner can delete a comment on their post' do
    sign_in users(:alice)

    assert_difference -> { @post.reload.comments_count }, -1 do
      delete post_comment_path(@post, comments(:carmen_on_alice)), xhr: true
    end
    assert_response :success
  end

  test 'a bystander cannot delete a comment' do
    sign_in users(:bruno)

    assert_no_difference 'Comment.count' do
      delete post_comment_path(@post, comments(:carmen_on_alice)), xhr: true
    end
    assert_response :forbidden
  end
end
