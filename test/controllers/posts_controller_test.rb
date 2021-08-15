require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  test 'a public post is visible to any signed-in user' do
    sign_in users(:bruno)

    get post_path(posts(:alice_post))

    assert_response :success
  end

  test 'a private account\'s post is hidden from non-followers' do
    sign_in users(:alice)

    get post_path(posts(:bruno_post))

    assert_redirected_to home_path
    assert_equal 'You are not authorized to perform this action.', flash[:alert]
  end

  test 'a follower can open a private account\'s post' do
    Follower.create!(follower_id: users(:alice).id, following_id: users(:bruno).id)
    sign_in users(:alice)

    get post_path(posts(:bruno_post))

    assert_response :success
  end

  test 'only the owner can delete a post' do
    sign_in users(:carmen)

    assert_no_difference 'Post.count' do
      delete post_path(posts(:alice_post))
    end

    sign_in users(:alice)
    assert_difference 'Post.count', -1 do
      delete post_path(posts(:alice_post))
    end
    assert_redirected_to home_path
  end

  test 'uploading a PNG creates a post' do
    sign_in users(:carmen)

    assert_difference -> { users(:carmen).posts.count }, 1 do
      post posts_path, params: { post: { image: fixture_file_upload('tiny.png', 'image/png'), post_type: 'post' } }
    end
    assert_redirected_to home_path
  end

  test 'an HTML file renamed to .png is refused' do
    sign_in users(:carmen)

    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { image: fixture_file_upload('disguised.png', 'image/png') } }
    end
    assert_redirected_to new_post_path
  end

  test 'a new story is scheduled to expire after the story lifetime' do
    sign_in users(:carmen)

    freeze_time do
      assert_enqueued_with(job: ClearStoryJob, at: Post.story_lifetime.from_now) do
        post posts_path, params: { post: { image: fixture_file_upload('tiny.png', 'image/png'), post_type: 'story' } }
      end
    end
  end

  test 'a regular post schedules nothing' do
    sign_in users(:carmen)

    assert_no_enqueued_jobs do
      post posts_path, params: { post: { image: fixture_file_upload('tiny.png', 'image/png'), post_type: 'post' } }
    end
  end
end
