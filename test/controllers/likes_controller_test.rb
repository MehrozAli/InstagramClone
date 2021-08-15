require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  test 'liking needs a signed-in user' do
    post like_post_path(posts(:alice_post)), xhr: true

    assert_response :unauthorized
  end

  test 'a GET request no longer changes likes' do
    sign_in users(:bruno)

    assert_no_difference 'Like.count' do
      get "/posts/#{posts(:alice_post).id}/like"
    end
    assert_response :not_found
  end

  test 'posting toggles the like on and off and keeps the counter in step' do
    sign_in users(:bruno)
    post_record = posts(:alice_post)

    post like_post_path(post_record), xhr: true
    assert_response :success
    assert_equal 2, post_record.reload.likes_count
    assert_match '2 likes', response.body

    post like_post_path(post_record), xhr: true
    assert_equal 1, post_record.reload.likes_count
  end

  test 'a private post cannot be liked by someone who cannot see it' do
    sign_in users(:alice)

    assert_no_difference 'Like.count' do
      post like_post_path(posts(:bruno_post)), xhr: true
    end
    assert_response :forbidden
  end
end
