require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def build_user(**attrs)
    User.new({ email: 'new@example.test', username: 'new_person', first_name: 'New',
               password: 'password123' }.merge(attrs))
  end

  test 'a complete user is valid' do
    assert build_user.valid?
  end

  test 'usernames must be URL-safe and fit the 20-character column' do
    assert_not build_user(username: 'has.dot').valid?
    assert_not build_user(username: 'has space').valid?
    assert_not build_user(username: 'a' * 21).valid?
  end

  test 'usernames are unique regardless of case' do
    assert_not build_user(username: 'ALICE_LENS').valid?
  end

  test 'names longer than the column limit are rejected instead of raising' do
    assert_not build_user(first_name: 'x' * 21).valid?
    assert_not build_user(last_name: 'x' * 21).valid?
  end

  test 'full_name ignores a missing last name' do
    assert_equal 'Alice Moreno', users(:alice).full_name
    assert_equal 'New', build_user.full_name
  end

  test 'follow counts and following?' do
    alice = users(:alice)
    carmen = users(:carmen)

    assert alice.following?(carmen.id)
    assert_not carmen.following?(alice.id)
    assert_equal 1, alice.total_following
    assert_equal 1, carmen.total_followers
  end

  test 'deleting a user removes their follow edges' do
    assert_difference 'Follower.count', -1 do
      users(:carmen).destroy
    end
  end
end
