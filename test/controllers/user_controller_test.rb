require 'test_helper'

class UserControllerTest < ActionDispatch::IntegrationTest
  test 'the feed needs a signed-in user' do
    get home_path

    assert_redirected_to new_user_session_path
  end

  test 'the feed shows followed and own posts but not strangers\' posts' do
    sign_in users(:carmen)
    posts(:carmen_story).update_columns(post_type: 'post')

    get home_path

    assert_response :success
    assert_select "img[src*='market.png']"
    assert_select "img[src*='harbour.png']", count: 0
  end

  test 'an unknown profile is a 404, not a crash' do
    sign_in users(:alice)

    get profile_path('nobody_here')

    assert_response :not_found
  end

  test 'a private profile hides its posts from non-followers' do
    sign_in users(:alice)

    get profile_path('bruno_frames')

    assert_response :success
    assert_select "img[src*='harbour.png']", count: 0
  end

  test 'following yourself is refused' do
    sign_in users(:alice)

    assert_no_difference 'Follower.count' do
      post follow_user_path, params: { follow_id: users(:alice).id }
    end
    assert_match "can't be yourself", flash[:alert]
  end

  test 'follow then unfollow' do
    sign_in users(:bruno)

    assert_difference 'Follower.count', 1 do
      post follow_user_path, params: { follow_id: users(:alice).id }
    end
    assert_difference 'Follower.count', -1 do
      post unfollow_user_path, params: { follow_id: users(:alice).id }
    end
  end

  test 'unfollowing someone you do not follow is handled' do
    sign_in users(:bruno)

    post unfollow_user_path, params: { follow_id: users(:alice).id }

    assert_redirected_to home_path
    assert_equal 'You are not following that user.', flash[:alert]
  end

  test 'search is case-insensitive and matches names' do
    sign_in users(:bruno)

    get search_path, params: { search: 'ALICE' }
    assert_select '.person-name', text: 'Alice Moreno'

    get search_path, params: { search: 'Ilves' }
    assert_select '.person-name', text: 'Carmen Ilves'
  end

  test 'search treats % and _ literally' do
    sign_in users(:bruno)

    get search_path, params: { search: '%' }

    assert_response :success
    assert_select '.person-name', text: 'Alice Moreno', count: 0
  end
end
