require 'test_helper'

class FollowerTest < ActiveSupport::TestCase
  test 'a user cannot follow themselves' do
    follow = Follower.new(follower: users(:alice), following: users(:alice))

    assert_not follow.valid?
  end

  test 'the same follow cannot be recorded twice' do
    follow = Follower.new(follower: users(:alice), following: users(:carmen))

    assert_not follow.valid?
  end

  test 'the database also refuses a duplicate follow' do
    assert_raises(ActiveRecord::RecordNotUnique) do
      Follower.insert!({ follower_id: users(:alice).id, following_id: users(:carmen).id })
    end
  end

  test 'following an unknown user is invalid' do
    assert_not Follower.new(follower: users(:alice), following_id: 0).valid?
  end
end
